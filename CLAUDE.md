# CLAUDE.md

## Project Overview

todoGuide is a GitBook that teaches developers how to use the vibestack framework — an opinionated convention system for AI-assisted development with Claude Code. The book covers installation, the core workflow (`/vibestack` -> `/todo populate` -> `/todo` -> `/docs`), all skills and commands, squad mode, and best practices. Content is written in Markdown and published via GitBook.

## Tech Stack

- Markdown — all book content
- GitBook — publishing platform (gitbook.com)
- Git/GitHub — version control and GitBook sync
- vibestack — the framework being documented (also used to manage this repo)

## Commands

All operations go through `ops.sh` — the single entry point for build, run, test, and deploy. Run `./ops.sh help` for the full list.

```bash
./ops.sh build
./ops.sh test
./ops.sh run
./ops.sh deploy <target>
./ops.sh logs <target>
./ops.sh status
```

## Project Structure

```
book/               # GitBook content — chapters and assets
  SUMMARY.md        # GitBook table of contents (chapter order + sidebar nav)
  README.md         # Book introduction / landing page
  getting-started/  # Installation, first run, quickstart
  core-concepts/    # CLAUDE.md, TODO.md, ops.sh, docs convention
  skills/           # Skill deep-dives (todo, squad, docs, bosskey, etc.)
  workflows/        # End-to-end workflow guides
  advanced/         # Squad mode, custom skills, CI guards
docs/               # Internal project docs (vibestack convention)
ops.sh              # Project CLI
TODO.md             # Task tracking
.claude/
  skills/           # Claude skills
```

## Architecture

Content-only project. The `book/` directory contains all GitBook chapters organized by topic. `book/SUMMARY.md` defines the sidebar navigation and chapter order. GitBook syncs from the GitHub repo — push to main and it publishes automatically.

## Key Workflows

### Docs

The `docs/` folder is the single source of truth for institutional knowledge. See `docs/README.md` for the full convention.

**For AI agents:** Before starting work on an unfamiliar area, check `docs/` for existing context. When you learn something significant during a task — integration quirks, architectural decisions, incident learnings — write it up or update an existing doc. Don't wait to be asked.

- Markdown files organized by topic in subdirectories
- `docs/SUMMARY.md` is the table of contents — update it when adding or removing docs
- Write as if explaining to a new team member who may be an AI agent

### TODO

`TODO.md` is a lightweight task tracker for human/AI collaboration.

**For AI agents:** Mark items `[~]` (pending) before starting so parallel agents don't collide. Mark `[x]` when done. Start from the top unless told otherwise.

### Skills

`.claude/skills/` teaches Claude project-specific conventions and provides reusable workflows as slash commands. See `docs/skills-and-commands.md` for how to create new ones.

**Reference skills** (auto-loaded as context):
- `cli-first` — Use CLI tools and `.env*` files for third-party services
- `lsp` — Use language servers for type checking, references, and code navigation

**Task skills** (invoked via `/command`):
- `/vibestack` — Set up VibeStack conventions for an existing project (CLAUDE.md, ops.sh, docs, TODO.md)
- `/docs` — Capture conversation learnings into docs and clean up stale content
- `/todo` — Work through TODO.md tasks sequentially (`/todo populate` to re-analyze the codebase and seed the next batch of tasks)
- `/squad` — Analyze the project and generate domain-specific rules and specialist subagents (`/squad refresh` to update)
- `/bosskey` — Summarize recent git activity into a standup script

## External Services

This project uses CLI tools for all third-party service interactions. Before using any external API or SDK, check `.env*` files for existing credentials and project configuration. Prefer CLI tools (`aws`, `vercel`, `supabase`, `gh`, `stripe`, `gcloud`, etc.) over web dashboards or raw API calls. See the `cli-first` skill for details.

## Conventions

- Chapter files use kebab-case filenames: `getting-started.md`, `squad-mode.md`
- Write in second person ("you") — direct and instructional
- Include concrete examples: real commands, real file contents, real output
- Every chapter should be self-contained enough to read standalone
- Code blocks use language hints (`bash`, `markdown`, `yaml`, `json`)
- Keep `book/SUMMARY.md` as the source of truth for chapter ordering
- **Publishing is user-only.** Claude can push code to GitHub, but must never publish or deploy to GitBook. The user is always the publisher.
