# Graph Report - .  (2026-04-08)

## Corpus Check
- 4 files · ~5,000 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 73 nodes · 94 edges · 10 communities detected
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 9 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## God Nodes (most connected - your core abstractions)
1. `Claude Code Hooks` - 35 edges
2. `CLAUDE.md (llm-wiki-work Project Instructions)` - 8 edges
3. `graphify-stop.sh Hook` - 8 edges
4. `Hook Decision Control` - 7 edges
5. `Graphify CLI (graphifyy package)` - 6 edges
6. `setup-graphify.sh` - 5 edges
7. `graphify-stop.sh Hook` - 4 edges
8. `wiki/index.md (Agent Entry Point)` - 4 edges
9. `greet()` - 4 edges
10. `farewell()` - 4 edges

## Surprising Connections (you probably didn't know these)
- `Graphify + Claude Code Setup` --conceptually_related_to--> `CLAUDE.md (llm-wiki-work Project Instructions)`  [INFERRED]
  graphify-setup.md → CLAUDE.md
- `Graph Report (2026-04-08)` --references--> `greet()`  [EXTRACTED]
  wiki/graphify-out/GRAPH_REPORT.md → local/helper.py
- `Graph Report (2026-04-08)` --references--> `farewell()`  [EXTRACTED]
  wiki/graphify-out/GRAPH_REPORT.md → local/helper.py
- `Graphify In-Session Rebuild Command` --calls--> `Graphify CLI (graphifyy package)`  [EXTRACTED]
  CLAUDE.md → graphify-setup.md
- `CLAUDE.md (llm-wiki-work Project Instructions)` --references--> `GRAPH_REPORT.md (God Nodes & Communities)`  [EXTRACTED]
  CLAUDE.md → graphify-setup.md

## Hyperedges (group relationships)
- **Hook Handler Types** — hooks_handler_command, hooks_handler_http, hooks_handler_prompt, hooks_handler_agent [EXTRACTED 1.00]
- **Hook Lifecycle Events** — hooks_event_sessionstart, hooks_event_sessionend, hooks_event_pretooluse, hooks_event_posttooluse, hooks_event_stop, hooks_event_precompact, hooks_event_postcompact [EXTRACTED 1.00]
- **Hook Events with Decision Control** — hooks_event_pretooluse, hooks_event_sessionstart, hooks_event_taskcreated, hooks_event_taskcompleted, hooks_event_teammateidle, hooks_event_workstreecreate [EXTRACTED 1.00]

## Communities

### Community 0 - "Hook Events Catalog"
Cohesion: 0.09
Nodes (23): Claude Code Hooks, ConfigChange Hook Event, CwdChanged Hook Event, Elicitation Hook Event, ElicitationResult Hook Event, FileChanged Hook Event, InstructionsLoaded Hook Event, Notification Hook Event (+15 more)

### Community 1 - "Wiki & Obsidian Config"
Cohesion: 0.19
Nodes (16): Graphify In-Session Rebuild Command, CLAUDE.md (llm-wiki-work Project Instructions), obsidian-bases Skill, obsidian-cli Skill, obsidian-markdown Skill, Obsidian Vault (llm-wiki-work), Claude Global Settings (~/.claude/settings.json), graph.json (Raw Graph Data) (+8 more)

### Community 2 - "Graphify Session Hooks"
Cohesion: 0.21
Nodes (13): graphify.detect.detect_incremental, graphify-session-init.sh Hook, graphify-stop.sh Hook, Graphify Knowledge Graph System, Obsidian LLM Wiki Vault, Rationale: Hooks enforce deterministic behavior, Rationale: Stop hooks early-exit guard, graphify.watch._rebuild_code (+5 more)

### Community 3 - "Graph Reports & Misc"
Cohesion: 0.8
Nodes (4): Graph Report (2026-04-08), farewell(), greet(), shout()

### Community 4 - "Hook Decision Control"
Cohesion: 0.4
Nodes (5): Hook Decision Control, TaskCompleted Hook Event, TaskCreated Hook Event, TeammateIdle Hook Event, WorktreeCreate Hook Event

### Community 5 - "Hook Config & Matchers"
Cohesion: 0.67
Nodes (3): Hooks Configuration in settings.json, PreToolUse Hook Event, Hook Matcher Patterns

### Community 6 - "Command Handler & Security"
Cohesion: 0.67
Nodes (3): Exit Code 2 Shows Output to Claude as Message, Command Hook Handler, Hook Security Considerations

### Community 7 - "Async & Background Hooks"
Cohesion: 1.0
Nodes (2): Background Async Hooks, Stop Hook Event

### Community 8 - "Session Lifecycle"
Cohesion: 1.0
Nodes (2): SessionStart Hook Event, SessionStart Matchers (startup/resume/clear/compact)

### Community 9 - "Hook Lifecycle Reference"
Cohesion: 1.0
Nodes (1): Hook Lifecycle Flow

## Knowledge Gaps
- **34 isolated node(s):** `wiki-auto-commit.sh Hook`, `Obsidian Vault (llm-wiki-work)`, `obsidian-markdown Skill`, `obsidian-cli Skill`, `obsidian-bases Skill` (+29 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Async & Background Hooks`** (2 nodes): `Background Async Hooks`, `Stop Hook Event`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Session Lifecycle`** (2 nodes): `SessionStart Hook Event`, `SessionStart Matchers (startup/resume/clear/compact)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Hook Lifecycle Reference`** (1 nodes): `Hook Lifecycle Flow`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Claude Code Hooks` connect `Hook Events Catalog` to `Hook Decision Control`, `Hook Config & Matchers`, `Command Handler & Security`, `Async & Background Hooks`, `Session Lifecycle`?**
  _High betweenness centrality (0.251) - this node is a cross-community bridge._
- **What connects `wiki-auto-commit.sh Hook`, `Obsidian Vault (llm-wiki-work)`, `obsidian-markdown Skill` to the rest of the system?**
  _34 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Hook Events Catalog` be split into smaller, more focused modules?**
  _Cohesion score 0.09 - nodes in this community are weakly interconnected._