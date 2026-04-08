# Graph Report - .  (2026-04-08)

## Corpus Check
- Corpus is ~700 words - fits in a single context window. You may not need a graph.

## Summary
- 16 nodes · 23 edges · 4 communities detected
- Extraction: 87% EXTRACTED · 13% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## God Nodes (most connected - your core abstractions)
1. `CLAUDE.md (llm-wiki-work Project Instructions)` - 8 edges
2. `Graphify CLI (graphifyy package)` - 6 edges
3. `setup-graphify.sh` - 5 edges
4. `graphify-stop.sh Hook` - 4 edges
5. `wiki/index.md (Agent Entry Point)` - 4 edges
6. `graphify-session-init.sh Hook` - 3 edges
7. `Claude Global Settings (~/.claude/settings.json)` - 3 edges
8. `Graphify + Claude Code Setup` - 2 edges
9. `graph.json (Raw Graph Data)` - 2 edges
10. `GRAPH_REPORT.md (God Nodes & Communities)` - 2 edges

## Surprising Connections (you probably didn't know these)
- `Graphify + Claude Code Setup` --conceptually_related_to--> `CLAUDE.md (llm-wiki-work Project Instructions)`  [INFERRED]
  graphify-setup.md → CLAUDE.md
- `CLAUDE.md (llm-wiki-work Project Instructions)` --references--> `GRAPH_REPORT.md (God Nodes & Communities)`  [EXTRACTED]
  CLAUDE.md → graphify-setup.md
- `Graphify In-Session Rebuild Command` --calls--> `Graphify CLI (graphifyy package)`  [EXTRACTED]
  CLAUDE.md → graphify-setup.md
- `CLAUDE.md (llm-wiki-work Project Instructions)` --references--> `wiki/index.md (Agent Entry Point)`  [EXTRACTED]
  CLAUDE.md → graphify-setup.md

## Hyperedges (group relationships)
- **Graphify Automation Pipeline (Hooks + CLI + Outputs)** — graphifysetup_session_init_hook, graphifysetup_session_stop_hook, graphifysetup_wiki_auto_commit_hook, graphifysetup_graphify_cli, graphifysetup_graph_json, graphifysetup_graph_report, graphifysetup_wiki_index [EXTRACTED 0.95]
- **Claude Code Project Integration (CLAUDE.md + Skills + Graphify)** — claudemd_llm_wiki_claude_md, claudemd_obsidian_markdown_skill, claudemd_obsidian_cli_skill, claudemd_obsidian_bases_skill, claudemd_graphify_rebuild_command, graphifysetup_graph_report, graphifysetup_wiki_index [INFERRED 0.85]

## Communities

### Community 0 - "Obsidian & Wiki Config"
Cohesion: 0.33
Nodes (6): CLAUDE.md (llm-wiki-work Project Instructions), obsidian-bases Skill, obsidian-cli Skill, obsidian-markdown Skill, Obsidian Vault (llm-wiki-work), Graphify + Claude Code Setup

### Community 1 - "Graphify CLI & Outputs"
Cohesion: 0.5
Nodes (4): Graphify In-Session Rebuild Command, graph.json (Raw Graph Data), GRAPH_REPORT.md (God Nodes & Communities), Graphify CLI (graphifyy package)

### Community 2 - "Hook & Setup Infrastructure"
Cohesion: 0.83
Nodes (4): Claude Global Settings (~/.claude/settings.json), graphify-session-init.sh Hook, graphify-stop.sh Hook, setup-graphify.sh

### Community 3 - "Wiki Sync & Publishing"
Cohesion: 1.0
Nodes (2): wiki-auto-commit.sh Hook, wiki/index.md (Agent Entry Point)

## Knowledge Gaps
- **5 isolated node(s):** `wiki-auto-commit.sh Hook`, `Obsidian Vault (llm-wiki-work)`, `obsidian-markdown Skill`, `obsidian-cli Skill`, `obsidian-bases Skill`
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Wiki Sync & Publishing`** (2 nodes): `wiki-auto-commit.sh Hook`, `wiki/index.md (Agent Entry Point)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `CLAUDE.md (llm-wiki-work Project Instructions)` connect `Obsidian & Wiki Config` to `Graphify CLI & Outputs`, `Wiki Sync & Publishing`?**
  _High betweenness centrality (0.543) - this node is a cross-community bridge._
- **Why does `wiki/index.md (Agent Entry Point)` connect `Wiki Sync & Publishing` to `Obsidian & Wiki Config`, `Graphify CLI & Outputs`, `Hook & Setup Infrastructure`?**
  _High betweenness centrality (0.269) - this node is a cross-community bridge._
- **Why does `Graphify CLI (graphifyy package)` connect `Graphify CLI & Outputs` to `Hook & Setup Infrastructure`, `Wiki Sync & Publishing`?**
  _High betweenness centrality (0.243) - this node is a cross-community bridge._
- **What connects `wiki-auto-commit.sh Hook`, `Obsidian Vault (llm-wiki-work)`, `obsidian-markdown Skill` to the rest of the system?**
  _5 weakly-connected nodes found - possible documentation gaps or missing edges._