# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work, mark the item as pending `[~]` so parallel agents don't collide. After completion, mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [~] Initialize git repo and push to GitHub — `git init`, create `.gitignore`, initial commit, create remote repo with `gh`, push via SSH
- [ ] Write `book/getting-started/what-is-vibestack.md` — explain the problem (AI agents guess without context), the solution (opinionated conventions), and the four design opinions
- [ ] Write `book/getting-started/installation.md` — cover the curl install, what files get created, the `claw` alias, and plugin mode
- [ ] Write `book/getting-started/first-run.md` — walk through the full first-time workflow: `/vibestack` -> `/todo populate` -> `/todo` -> `/docs`
- [ ] Write `book/core-concepts/claude-md.md` — explain each section of CLAUDE.md, why it matters, and how to fill it out for different project types
- [ ] Write `book/core-concepts/todo-md.md` — cover the `[ ]`/`[~]`/`[x]` convention, agent collision prevention, and how populate works
- [ ] Write `book/core-concepts/ops-sh.md` — explain the single-entry-point philosophy, walk through each command block, show how to add custom commands
- [ ] Write `book/core-concepts/docs.md` — cover the docs convention, SUMMARY.md, when to write docs, the Feynman clarity pass
- [ ] Write `book/skills/how-skills-work.md` — explain reference vs task skills, SKILL.md frontmatter, arguments, file structure
- [ ] Write `book/skills/vibestack.md` — deep dive on what `/vibestack` does: project analysis, CLAUDE.md population, ops.sh configuration, doc seeding, TODO seeding
- [ ] Write `book/skills/todo.md` — cover `/todo` (run mode) and `/todo populate` (populate mode), prioritization framework, task format
- [ ] Write `book/skills/squad.md` — explain domain identification, rule generation, specialist subagents, manifest file, refresh workflow
- [ ] Write `book/skills/docs.md` — cover `/docs` skill: context gathering, doc capture, cleanup pass, Feynman clarity pass
- [ ] Write `book/skills/bosskey.md` — explain the standup generator: git analysis, tone rules, translation guide, output formats
- [ ] Write `book/skills/reference-skills.md` — document cli-first (CLI over dashboards, env vars) and lsp (language server integration)
- [ ] Write `book/skills/custom-skills.md` — guide for creating new skills: when to write one, frontmatter options, examples, personal vs project scope
- [ ] Write `book/workflows/full-loop.md` — end-to-end walkthrough of a vibestack session from install to shipping code
- [ ] Write `book/workflows/solo-developer.md` — patterns for solo devs: fast iteration, using TODO as a roadmap, keeping docs for future-you
- [ ] Write `book/workflows/team-collaboration.md` — multi-developer patterns: agent collision prevention, shared CLAUDE.md, squad for domain ownership
- [ ] Write `book/advanced/squad-mode.md` — deep dive: when to use it, domain identification heuristics, rules vs subagents, refresh workflow
- [ ] Write `book/advanced/ci-guards.md` — cover the CI workflow templates: lint, coverage, security scanning for Node/Python/Rust/Go
- [ ] Write `book/advanced/settings-and-hooks.md` — document settings.json (permissions, env, statusLine) and hooks (notify-done, statusline)
- [ ] Write `book/advanced/tips.md` — common pitfalls, debugging tips, FAQ, performance tips for large codebases
