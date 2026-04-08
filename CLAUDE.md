# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a personal knowledge wiki built with Obsidian—a vault for capturing learnings, solutions, patterns, and references from daily work. It serves as a living knowledge base that Claude Code can reference when working on related projects.

## Obsidian Vault Structure

**Conventions:**
- Use folder hierarchies to organize by topic (e.g., `databases/`, `architecture/`, `devops/`)
- Create index notes at folder levels (`_index.md`) to list key concepts and provide navigation
- Use wikilinks (`[[Note Title]]`) for cross-references between notes
- Prefix reference index files with `_` to surface them visually

**Skills:**
- Use `/obsidian-markdown` to create or edit notes with proper Obsidian formatting (wikilinks, embeds, callouts, properties)
- Use `/obsidian-cli` to interact with the vault programmatically (search, create, read)
- Use `/obsidian-bases` if creating structured data/databases within the vault

## When Claude Code References This Wiki

When working on projects and this wiki is relevant:
- Claude Code will read notes from here for context and patterns
- Reference specific note titles with links: `[[Note Title]]`
- If a note doesn't exist but would be useful, suggest creating it via `/obsidian-markdown`

## Note Properties

Use Obsidian YAML frontmatter for metadata:
```yaml
---
type: pattern | solution | learning | reference | howto
domain: [category]
status: active | archived | wip
updated: YYYY-MM-DD
---
```

This enables filtering and future querying of the vault.

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- After modifying code files in this session, run `python3 -c "from graphify.watch import _rebuild_code; from pathlib import Path; _rebuild_code(Path('.'))"` to keep the graph current
