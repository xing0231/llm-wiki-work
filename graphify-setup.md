---
type: howto
domain: [tooling, graphify, claude-code]
status: active
updated: 2026-04-08
---

# Graphify + Claude Code Setup

How to replicate the graphify knowledge graph integration for `llm-wiki-work` on a new machine.

## Prerequisites

- `pipx` installed
- Claude Code CLI installed
- `llm-wiki-work` repo cloned to `~/llm-wiki-work`
- Obsidian vault synced to `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/llm-wiki-work`

## One-command setup

```bash
cd ~/llm-wiki-work
chmod +x setup-graphify.sh && ./setup-graphify.sh
```

Edit the path variables at the top of `setup-graphify.sh` if directories differ on the new machine.

## What the script does

| Step | Command | What it sets up |
|------|---------|-----------------|
| 1 | `pipx install graphifyy` | graphify CLI + Python package |
| 2 | writes hook scripts | `~/.claude/hooks/graphify-session-init.sh` and `graphify-stop.sh` |
| 3 | edits `~/.claude/settings.json` | registers Stop + PreToolUse hooks globally |
| 4 | `graphify claude install` | adds graphify section to project CLAUDE.md |
| 5 | `graphify hook install` | installs git post-commit + post-checkout hooks |

## Automatic behaviour after setup

| Trigger | What runs | LLM tokens? |
|---------|-----------|-------------|
| Session start (first Bash call) | Creates `wiki/graphify-out → ~/llm-wiki-work/graphify-out` symlink + starts `--watch` background process | None |
| `git commit` | AST rebuild for changed code files | None |
| `git checkout` | Syncs graph to new branch | None |
| Session end | AST rebuild if code changed + regenerates `graphify-out/wiki/` + auto-commit & push to remote | None |
| Docs/images changed | **Manual** — run `/graphify --update` | Yes (semantic) |

## First run on a new machine

After setup, build the initial graph:

```
/graphify ~/llm-wiki-work
```

This runs the full pipeline (LLM semantic extraction) once. Everything after that is incremental.

## Key file locations

| File | Purpose |
|------|---------|
| `~/llm-wiki-work/graphify-out/graph.json` | Raw graph data |
| `~/llm-wiki-work/graphify-out/GRAPH_REPORT.md` | God nodes, communities, suggested questions |
| `~/llm-wiki-work/graphify-out/wiki/index.md` | Agent entry point — start here |
| `~/.claude/hooks/graphify-session-init.sh` | Session start hook |
| `~/.claude/hooks/graphify-stop.sh` | Session end: AST rebuild + wiki regeneration |
| `~/.claude/hooks/wiki-auto-commit.sh` | Session end: auto-commit + push wiki to remote |
| `~/.claude/settings.json` | Global Claude hook registrations |

## Updating hooks manually

If the hooks need to change, edit the scripts directly:

```bash
nano ~/.claude/hooks/graphify-stop.sh
nano ~/.claude/hooks/graphify-session-init.sh
```

No need to re-register in `settings.json` — the paths don't change.
