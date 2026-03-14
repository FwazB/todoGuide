# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work, mark the item as pending `[~]` so parallel agents don't collide. After completion, mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [x] Fix nested code block in `book/core-concepts/claude-md.md` — line 54-57 has a ``` inside a ```markdown fence which breaks rendering; use indented code blocks or ~~~~ fencing for the inner block
- [x] Expand `book/getting-started/quickstart.md` — currently 120 words, too thin; add expected output after each step, a "verify it worked" check, and a troubleshooting note for common issues
- [ ] Add real terminal output examples to `book/getting-started/installation.md` — show what the installer actually prints, what `claw` looks like when launched, and sample `/vibestack` output
- [x] Add a "Before & After" section to `book/getting-started/what-is-vibestack.md` — write a realistic side-by-side showing Claude without vibestack (guessing file structure, wrong commands) vs with vibestack (using ops.sh, following conventions)
- [x] Proofread all chapters for typos, grammar, and awkward phrasing — do a line-by-line pass across all 26 markdown files in `book/`
- [x] Add concrete CLI examples to `book/skills/reference-skills.md` — already has 5 real-world CLI examples (Vercel env, S3 upload, Supabase migration, GitHub release, Stripe webhooks)
- [ ] Review and improve all chapter introductions — each chapter's first paragraph should hook the reader and clearly state what they'll learn; some are dry
- [x] Add a "Common Patterns" appendix at `book/advanced/patterns.md` — collect recurring vibestack patterns: how to handle monorepos, how to migrate from an existing CLAUDE.md, how to onboard a new team member
- [x] Fix `ops.sh status` output — extra `0` printed on its own line after the task stats section; debug and remove
- [x] Verify all cross-chapter links work — run a deeper link check that validates internal markdown links (not just SUMMARY.md refs) across all chapters
