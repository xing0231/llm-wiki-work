#!/usr/bin/env bash
# setup-graphify.sh
# Replicates the full graphify + Claude Code integration for llm-wiki-work.
# Run once on a new machine after cloning the repo.
#
# Usage:
#   chmod +x setup-graphify.sh && ./setup-graphify.sh
#
# Edit the variables below before running on a new machine.

set -euo pipefail

# ── Configure these for the new machine ─────────────────────────────────────
LOCAL_WIKI_DIR="$HOME/llm-wiki-work"
OBSIDIAN_VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/llm-wiki-work"
CLAUDE_HOOKS_DIR="$HOME/.claude/hooks"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
# ────────────────────────────────────────────────────────────────────────────

echo "==> [1/5] Installing graphify via pipx..."
if command -v graphify &>/dev/null; then
  echo "    graphify already installed: $(graphify --version 2>/dev/null || echo 'ok')"
else
  pipx install graphifyy
fi

# Resolve the pipx Python used by graphify
GRAPHIFY_BIN=$(which graphify)
GRAPHIFY_PYTHON=$(head -1 "$GRAPHIFY_BIN" | tr -d '#!')
echo "    Python: $GRAPHIFY_PYTHON"

echo "==> [2/5] Installing global Claude hook scripts..."
mkdir -p "$CLAUDE_HOOKS_DIR"

# ── session-init hook ────────────────────────────────────────────────────────
cat > "$CLAUDE_HOOKS_DIR/graphify-session-init.sh" <<HOOK
#!/usr/bin/env bash
# graphify-session-init — runs once per Claude Code session (keyed on parent PID)
SENTINEL="/tmp/claude-graphify-init-\${PPID}"
[ -f "\$SENTINEL" ] && exit 0
touch "\$SENTINEL"

LOCAL_OUT="${LOCAL_WIKI_DIR}/graphify-out"
WIKI_OUT="${OBSIDIAN_VAULT_DIR}/graphify-out"

mkdir -p "\$LOCAL_OUT"

if [ ! -e "\$WIKI_OUT" ] && [ ! -L "\$WIKI_OUT" ]; then
    ln -s "\$LOCAL_OUT" "\$WIKI_OUT"
    echo "[graphify] Symlink created: wiki/graphify-out → \$LOCAL_OUT" >&2
elif [ -L "\$WIKI_OUT" ]; then
    echo "[graphify] Symlink already exists: \$WIKI_OUT" >&2
fi

WATCH_PID_FILE="/tmp/claude-graphify-watch-\${PPID}.pid"
if [ ! -f "\$WATCH_PID_FILE" ] || ! kill -0 "\$(cat "\$WATCH_PID_FILE")" 2>/dev/null; then
    nohup python3 -m graphify.watch "${LOCAL_WIKI_DIR}" --debounce 3 \
        > /tmp/graphify-watch.log 2>&1 &
    echo \$! > "\$WATCH_PID_FILE"
    echo "[graphify] Watch started (PID: \$(cat "\$WATCH_PID_FILE"))" >&2
fi
exit 0
HOOK
chmod +x "$CLAUDE_HOOKS_DIR/graphify-session-init.sh"
echo "    Written: graphify-session-init.sh"

# ── stop hook ────────────────────────────────────────────────────────────────
cat > "$CLAUDE_HOOKS_DIR/graphify-stop.sh" <<HOOK
#!/usr/bin/env bash
# graphify-stop — runs after each Claude session (Stop hook)
# AST rebuild for changed code + wiki regeneration. No LLM tokens.
PYTHON=${GRAPHIFY_PYTHON}
cat > /dev/null
[ -f "graphify-out/graph.json" ] || exit 0

\$PYTHON - <<'PYEOF'
import sys
from pathlib import Path

graph_path = Path("graphify-out/graph.json")
if not graph_path.exists():
    sys.exit(0)

CODE_EXTS = {
    '.py', '.ts', '.js', '.go', '.rs', '.java', '.cpp', '.c', '.rb', '.swift',
    '.kt', '.cs', '.scala', '.php', '.cc', '.cxx', '.hpp', '.h', '.kts',
}

try:
    from graphify.detect import detect_incremental, save_manifest
    result = detect_incremental(Path('.'))
    new_files = result.get('new_files', {})
    all_changed = [f for files in new_files.values() for f in files]
    code_changed = [f for f in all_changed if Path(f).suffix.lower() in CODE_EXTS]
    has_non_code = any(new_files.get(k) for k in ('document', 'paper', 'image'))

    if code_changed and not has_non_code:
        from graphify.watch import _rebuild_code
        print(f"[graphify stop] {len(code_changed)} code file(s) changed — AST rebuild...", flush=True)
        ok = _rebuild_code(Path('.'))
        if ok:
            save_manifest(result['files'])
            print("[graphify stop] Graph rebuilt.", flush=True)
    elif has_non_code:
        print("[graphify stop] Docs/images changed — run /graphify --update for semantic re-extraction.", flush=True)
    else:
        print("[graphify stop] No code changes.", flush=True)
except Exception as e:
    print(f"[graphify stop] Update skipped: {e}", flush=True)

try:
    import json
    from graphify.build import build_from_json
    from graphify.cluster import cluster, score_all
    from graphify.analyze import god_nodes
    from graphify.wiki import to_wiki

    G = build_from_json(json.loads(graph_path.read_text()))
    if G.number_of_nodes() == 0:
        sys.exit(0)

    communities = cluster(G)
    cohesion = score_all(G, communities)
    gods = god_nodes(G)

    labels_path = Path('.graphify_labels.json')
    if labels_path.exists():
        raw = json.loads(labels_path.read_text())
        labels = {int(k): v for k, v in raw.items()}
    else:
        labels = {cid: f"Community {cid}" for cid in communities}

    n = to_wiki(G, communities, 'graphify-out/wiki',
                community_labels=labels, cohesion=cohesion, god_nodes_data=gods)
    print(f"[graphify stop] Wiki regenerated — {n} articles in graphify-out/wiki/", flush=True)
except Exception as e:
    print(f"[graphify stop] Wiki skipped: {e}", flush=True)
PYEOF
HOOK
chmod +x "$CLAUDE_HOOKS_DIR/graphify-stop.sh"
echo "    Written: graphify-stop.sh"

# ── wiki-auto-commit hook ─────────────────────────────────────────────────────
cat > "$CLAUDE_HOOKS_DIR/wiki-auto-commit.sh" <<HOOK
#!/usr/bin/env bash
# wiki-auto-commit — auto-commit and push llm-wiki-work after each Claude session.
WIKI_DIR="${OBSIDIAN_VAULT_DIR}"
cat > /dev/null
cd "\$WIKI_DIR" || exit 0
git diff --quiet && git diff --cached --quiet && [ -z "\$(git ls-files --others --exclude-standard)" ] && {
    echo "[wiki] No changes to commit." >&2; exit 0
}
git add -A
CHANGED_COUNT=\$(git diff --cached --name-only | wc -l | tr -d ' ')
CHANGED_SUMMARY=\$(git diff --cached --name-only | head -5 | paste -sd ', ' -)
[ "\$CHANGED_COUNT" -gt 5 ] && CHANGED_SUMMARY="\${CHANGED_SUMMARY}, ..."
TIMESTAMP=\$(date '+%Y-%m-%d %H:%M')
git commit -m "wiki: auto-update \${TIMESTAMP}

\${CHANGED_COUNT} file(s) changed: \${CHANGED_SUMMARY}

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>" --no-gpg-sign 2>&1
BRANCH=\$(git rev-parse --abbrev-ref HEAD)
if git push origin "\$BRANCH" 2>/dev/null; then
    echo "[wiki] Pushed to origin/\${BRANCH}." >&2
elif git push --set-upstream origin "\$BRANCH" 2>&1; then
    echo "[wiki] First push — upstream set to origin/\${BRANCH}." >&2
else
    echo "[wiki] Push failed (no network?). Committed locally." >&2
fi
HOOK
chmod +x "$CLAUDE_HOOKS_DIR/wiki-auto-commit.sh"
echo "    Written: wiki-auto-commit.sh"

echo "==> [3/5] Registering hooks in Claude settings.json..."
# Ensure the hooks block exists and contains both hooks.
# Uses Python for safe JSON manipulation.
python3 - <<PYEOF
import json
from pathlib import Path

settings_path = Path("${CLAUDE_SETTINGS}")
settings = json.loads(settings_path.read_text()) if settings_path.exists() else {}

hooks = settings.setdefault("hooks", {})

# Stop hooks (graphify rebuild + wiki auto-commit) — both in one entry
stop_hooks = hooks.setdefault("Stop", [])
stop_cmds = [
    "${CLAUDE_HOOKS_DIR}/graphify-stop.sh",
    "${CLAUDE_HOOKS_DIR}/wiki-auto-commit.sh",
]
existing_stop_cmds = {h.get("command") for entry in stop_hooks for h in entry.get("hooks", [])}
new_stop_cmds = [c for c in stop_cmds if c not in existing_stop_cmds]
if new_stop_cmds:
    if stop_hooks:
        stop_hooks[0]["hooks"].extend([{"type": "command", "command": c} for c in new_stop_cmds])
    else:
        stop_hooks.append({"hooks": [{"type": "command", "command": c} for c in stop_cmds]})
    print(f"    Added Stop hooks: {new_stop_cmds}")
else:
    print("    Stop hooks already present.")

# PreToolUse session-init hook
pre_hooks = hooks.setdefault("PreToolUse", [])
init_cmd = "${CLAUDE_HOOKS_DIR}/graphify-session-init.sh"
added = False
for entry in pre_hooks:
    if entry.get("matcher") == "Bash":
        existing_cmds = [h.get("command") for h in entry.get("hooks", [])]
        if init_cmd not in existing_cmds:
            entry["hooks"].insert(0, {"type": "command", "command": init_cmd})
            added = True
        break
else:
    pre_hooks.append({"matcher": "Bash", "hooks": [{"type": "command", "command": init_cmd}]})
    added = True

print("    Added PreToolUse session-init hook." if added else "    PreToolUse session-init hook already present.")

settings_path.write_text(json.dumps(settings, indent=2))
PYEOF

echo "==> [4/5] Running 'graphify claude install' in project dir..."
cd "$LOCAL_WIKI_DIR"
graphify claude install

echo "==> [5/5] Installing git hooks in project repo..."
cd "$LOCAL_WIKI_DIR"
graphify hook install

echo ""
echo "✓ Setup complete."
echo ""
echo "What runs automatically:"
echo "  Session start  → symlink wiki/graphify-out → local, start --watch"
echo "  git commit     → AST rebuild for code changes (no LLM)"
echo "  git checkout   → sync graph to branch"
echo "  Session end    → AST rebuild if code changed + wiki regenerated + auto-commit & push"
echo ""
echo "First time: run '/graphify ${LOCAL_WIKI_DIR}' to build the initial graph."
