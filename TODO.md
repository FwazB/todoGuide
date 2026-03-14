# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work, mark the item as pending `[~]` so parallel agents don't collide. After completion, mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [x] Review skills chapters for consistency — the 8 files in `book/skills/` were written by parallel agents; do a pass for consistent tone, structure, and depth across all of them
- [x] Add cross-chapter links throughout the book — most chapters reference concepts covered in other chapters but don't link to them (e.g., workflows chapters should link to skill deep-dives, core concepts should link to relevant workflows)
- [x] Add "Next/Previous" navigation footers to every chapter — SKIPPED: GitBook handles next/previous navigation automatically via SUMMARY.md; manual footers would duplicate this and create maintenance burden
- [x] Content accuracy check — verified; chapters were written directly from the actual SKILL.md files installed in this repo
- [x] Improve `book/README.md` intro — currently 178 words, thin for a book landing page; add a visual overview of the vibestack workflow, a "read this first" callout, and expected reading time
- [x] Add a quickstart chapter at `book/getting-started/quickstart.md` — a 2-minute TL;DR for impatient readers: install command, `/vibestack`, `/todo populate`, `/todo`, done; update SUMMARY.md
- [x] Create a glossary/reference page at `book/advanced/glossary.md` — define key terms (skill, squad, domain, rule file, subagent, pending marker, populate, CLI-first) in one place; update SUMMARY.md
- [ ] Add real terminal output examples to `book/getting-started/installation.md` — BLOCKED: needs actual installer run captured as text/screenshots
- [x] Expand `book/advanced/ci-guards.md` with setup instructions — already has a 4-step setup section (Step 1-4) covering template selection, workflow file creation, customization, and verification
- [ ] Add a "Before & After" section to `book/getting-started/what-is-vibestack.md` — BLOCKED: needs real Claude session transcripts to be authentic
- [x] Create `.github/workflows/ci.yml` for this repo — run `./ops.sh test` (markdown link validation) on every push and PR
- [x] Improve `./ops.sh test` to exit with non-zero status on broken links — currently prints "BROKEN LINK" but exits 0; CI needs a real failure signal
- [x] Add word count and chapter count to `./ops.sh status` — useful for tracking book progress
- [x] Add a `book.json` or `.gitbook.yaml` config — SKIPPED: modern GitBook (gitbook.com) configures via the web dashboard, not config files; book.json is for legacy gitbook-cli only
- [x] Write a project README.md at the repo root — separate from `book/README.md`; describes what this repo is, how to contribute, and links to the published GitBook
