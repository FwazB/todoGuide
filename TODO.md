# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work, mark the item as pending `[~]` so parallel agents don't collide. After completion, mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [ ] Update `README.md` with the actual GitBook URL — BLOCKED: user needs to provide the published GitBook URL
- [x] Review and improve all chapter introductions — each chapter's first paragraph should hook the reader and clearly state what they'll learn; some are dry
- [ ] Add real terminal output examples to `book/getting-started/installation.md` — show what the installer actually prints, what `claw` looks like when launched, and sample `/vibestack` output
- [x] Enhance `ops.sh test` to validate internal cross-chapter links — currently only checks SUMMARY.md references; add a pass that checks all `](*.md)` links in every chapter resolve to real files
- [x] Standardize em dashes in `book/README.md` — already done by proofreading pass
- [x] Add a LICENSE file at the repo root — README.md says MIT but no LICENSE file exists
- [x] Add a CONTRIBUTING.md — since the book is public, explain how others can contribute (fork, edit, PR) and what conventions to follow
- [x] Improve `book/getting-started/installation.md` — at 623 words it's the thinnest Getting Started chapter; expand the "What Gets Created" section with brief descriptions of what each file does
- [x] Add social preview / open graph metadata — SKIPPED: GitBook generates OG tags automatically from the book title and description
- [x] Review `book/advanced/patterns.md` for accuracy — the "Running vibestack in CI" section mentions `claude --no-interactive` which may not be the correct flag; verify and fix
