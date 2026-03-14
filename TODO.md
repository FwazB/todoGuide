# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work, mark the item as pending `[~]` so parallel agents don't collide. After completion, mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [ ] Review skills chapters for consistency — the 8 files in `book/skills/` were written by parallel agents; do a pass for consistent tone, structure, and depth across all of them
- [ ] Add cross-chapter links throughout the book — most chapters reference concepts covered in other chapters but don't link to them (e.g., workflows chapters should link to skill deep-dives, core concepts should link to relevant workflows)
- [ ] Add "Next/Previous" navigation footers to every chapter — each chapter should end with links to the next chapter (per SUMMARY.md order) and related chapters for further reading
- [ ] Content accuracy check — fetch the latest vibestack repo and verify all chapter content matches the actual SKILL.md files, install script behavior, and settings.json structure
- [ ] Improve `book/README.md` intro — currently 178 words, thin for a book landing page; add a visual overview of the vibestack workflow, a "read this first" callout, and expected reading time
- [ ] Add a quickstart chapter at `book/getting-started/quickstart.md` — a 2-minute TL;DR for impatient readers: install command, `/vibestack`, `/todo populate`, `/todo`, done; update SUMMARY.md
- [ ] Create a glossary/reference page at `book/advanced/glossary.md` — define key terms (skill, squad, domain, rule file, subagent, pending marker, populate, CLI-first) in one place; update SUMMARY.md
- [ ] Add real terminal output examples to `book/getting-started/installation.md` — show what the installer actually prints, what `claw` looks like when launched, and sample `/vibestack` output
- [ ] Expand `book/advanced/ci-guards.md` with setup instructions — currently shows templates but doesn't walk through creating `.github/workflows/ci.yml` step by step for a new project
- [ ] Add a "Before & After" section to `book/getting-started/what-is-vibestack.md` — show a concrete side-by-side of Claude working without vibestack vs with vibestack on the same task
- [ ] Create `.github/workflows/ci.yml` for this repo — run `./ops.sh test` (markdown link validation) on every push and PR
- [ ] Improve `./ops.sh test` to exit with non-zero status on broken links — currently prints "BROKEN LINK" but exits 0; CI needs a real failure signal
- [ ] Add word count and chapter count to `./ops.sh status` — useful for tracking book progress
- [ ] Add a `book.json` or `.gitbook.yaml` config — set the book title, description, and any GitBook-specific settings (plugins, theme, redirects)
- [ ] Write a project README.md at the repo root — separate from `book/README.md`; describes what this repo is, how to contribute, and links to the published GitBook
