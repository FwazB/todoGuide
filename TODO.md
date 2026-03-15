# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work, mark the item as pending `[~]` so parallel agents don't collide. After completion, mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [ ] Update `README.md` with the actual GitBook URL — replace the "*[GitBook link coming soon]*" placeholder once the book is published
- [ ] Review and improve all chapter introductions — each chapter's first paragraph should hook the reader and clearly state what they'll learn; some are dry
- [ ] Add real terminal output examples to `book/getting-started/installation.md` — show what the installer actually prints, what `claw` looks like when launched, and sample `/vibestack` output
- [ ] Enhance `ops.sh test` to validate internal cross-chapter links — currently only checks SUMMARY.md references; add a pass that checks all `](*.md)` links in every chapter resolve to real files
- [ ] Standardize em dashes in `book/README.md` — still uses `--` while the rest of the book was standardized to `—`
- [ ] Add a LICENSE file at the repo root — README.md says MIT but no LICENSE file exists
- [ ] Add a CONTRIBUTING.md — since the book is public, explain how others can contribute (fork, edit, PR) and what conventions to follow
- [ ] Improve `book/getting-started/installation.md` — at 623 words it's the thinnest Getting Started chapter; expand the "What Gets Created" section with brief descriptions of what each file does
- [ ] Add social preview / open graph metadata — create a `.gitbook.yaml` or add metadata to `book/README.md` for better link previews when the GitBook URL is shared
- [ ] Review `book/advanced/patterns.md` for accuracy — the "Running vibestack in CI" section mentions `claude --no-interactive` which may not be the correct flag; verify and fix
