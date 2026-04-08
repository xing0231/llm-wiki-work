# Graph Report - .  (2026-04-08)

## Corpus Check
- Corpus is ~422 words - fits in a single context window. You may not need a graph.

## Summary
- 35 nodes · 47 edges · 10 communities detected
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 5 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## God Nodes (most connected - your core abstractions)
1. `CLAUDE.md (llm-wiki-work Project Instructions)` - 8 edges
2. `graphify-stop.sh Hook` - 8 edges
3. `Graphify CLI (graphifyy package)` - 6 edges
4. `setup-graphify.sh` - 5 edges
5. `graphify-stop.sh Hook` - 4 edges
6. `wiki/index.md (Agent Entry Point)` - 4 edges
7. `greet()` - 4 edges
8. `farewell()` - 4 edges
9. `~/.claude/settings.json` - 4 edges
10. `graphify-session-init.sh Hook` - 3 edges

## Surprising Connections (you probably didn't know these)
- `Graphify + Claude Code Setup` --conceptually_related_to--> `CLAUDE.md (llm-wiki-work Project Instructions)`  [INFERRED]
  graphify-setup.md → CLAUDE.md
- `CLAUDE.md (llm-wiki-work Project Instructions)` --references--> `GRAPH_REPORT.md (God Nodes & Communities)`  [EXTRACTED]
  CLAUDE.md → graphify-setup.md
- `Graph Report (2026-04-08)` --references--> `greet()`  [EXTRACTED]
  wiki/graphify-out/GRAPH_REPORT.md → local/helper.py
- `Graph Report (2026-04-08)` --references--> `farewell()`  [EXTRACTED]
  wiki/graphify-out/GRAPH_REPORT.md → local/helper.py
- `Graphify In-Session Rebuild Command` --calls--> `Graphify CLI (graphifyy package)`  [EXTRACTED]
  CLAUDE.md → graphify-setup.md

## Hyperedges (group relationships)
- **Graphify Auto-Update Pipeline** — claudehooks_graphify_stop, claudehooks_detect_incremental, claudehooks_rebuild_code, claudehooks_to_wiki [EXTRACTED 1.00]
- **Claude Code Hooks System** — claudehooks_graphify_session_init, claudehooks_graphify_stop, claudehooks_wiki_auto_commit, claudehooks_rtk_rewrite, claudehooks_settings_json [EXTRACTED 1.00]
- **Functions calling greet()** — helper_greet, helper_farewell, helper_shout [EXTRACTED 1.00]

## Communities

### Community 0 - "Obsidian Skills"
Cohesion: 0.4
Nodes (5): CLAUDE.md (llm-wiki-work Project Instructions), obsidian-bases Skill, obsidian-cli Skill, obsidian-markdown Skill, Obsidian Vault (llm-wiki-work)

### Community 1 - "Helper Functions & Reports"
Cohesion: 0.8
Nodes (4): Graph Report (2026-04-08), farewell(), greet(), shout()

### Community 2 - "Graphify Core Setup"
Cohesion: 0.5
Nodes (4): Graphify In-Session Rebuild Command, graph.json (Raw Graph Data), GRAPH_REPORT.md (God Nodes & Communities), Graphify CLI (graphifyy package)

### Community 3 - "Claude Settings & Session Init"
Cohesion: 0.67
Nodes (4): Claude Global Settings (~/.claude/settings.json), Graphify + Claude Code Setup, graphify-session-init.sh Hook, setup-graphify.sh

### Community 4 - "Graphify Stop Hook Pipeline"
Cohesion: 0.5
Nodes (4): graphify.detect.detect_incremental, graphify-stop.sh Hook, graphify.watch._rebuild_code, graphify.wiki.to_wiki

### Community 5 - "Stop Hook & Wiki Commit"
Cohesion: 0.67
Nodes (3): graphify-stop.sh Hook, wiki-auto-commit.sh Hook, wiki/index.md (Agent Entry Point)

### Community 6 - "Obsidian Wiki Automation"
Cohesion: 0.67
Nodes (3): Obsidian LLM Wiki Vault, Rationale: Stop hooks early-exit guard, wiki-auto-commit.sh Hook

### Community 7 - "Graphify Session System"
Cohesion: 0.67
Nodes (3): graphify-session-init.sh Hook, Graphify Knowledge Graph System, Rationale: Hooks enforce deterministic behavior

### Community 8 - "RTK Token Optimization"
Cohesion: 0.67
Nodes (3): RTK (Rust Token Killer), rtk-rewrite.sh Hook, ~/.claude/settings.json

### Community 9 - "Hook Lifecycle"
Cohesion: 1.0
Nodes (1): Hook Lifecycle Flow

## Knowledge Gaps
- **11 isolated node(s):** `wiki-auto-commit.sh Hook`, `Obsidian Vault (llm-wiki-work)`, `obsidian-markdown Skill`, `obsidian-cli Skill`, `obsidian-bases Skill` (+6 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Hook Lifecycle`** (1 nodes): `Hook Lifecycle Flow`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `CLAUDE.md (llm-wiki-work Project Instructions)` connect `Obsidian Skills` to `Graphify Core Setup`, `Claude Settings & Session Init`, `Stop Hook & Wiki Commit`?**
  _High betweenness centrality (0.102) - this node is a cross-community bridge._
- **Why does `graphify-stop.sh Hook` connect `Graphify Stop Hook Pipeline` to `RTK Token Optimization`, `Obsidian Wiki Automation`, `Graphify Session System`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Why does `wiki/index.md (Agent Entry Point)` connect `Stop Hook & Wiki Commit` to `Obsidian Skills`, `Graphify Core Setup`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **What connects `wiki-auto-commit.sh Hook`, `Obsidian Vault (llm-wiki-work)`, `obsidian-markdown Skill` to the rest of the system?**
  _11 weakly-connected nodes found - possible documentation gaps or missing edges._