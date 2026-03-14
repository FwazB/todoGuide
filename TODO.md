# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work, mark the item as pending `[~]` so parallel agents don't collide. After completion, mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [x] Initialize git repo and push to GitHub — `git init`, create `.gitignore`, initial commit, create remote repo with `gh`, push via SSH
- [x] Write `book/getting-started/what-is-vibestack.md` — explain the problem (AI agents guess without context), the solution (opinionated conventions), and the four design opinions
- [x] Write `book/getting-started/installation.md` — cover the curl install, what files get created, the `claw` alias, and plugin mode
- [x] Write `book/getting-started/first-run.md` — walk through the full first-time workflow: `/vibestack` -> `/todo populate` -> `/todo` -> `/docs`
- [x] Write `book/core-concepts/claude-md.md` — explain each section of CLAUDE.md, why it matters, and how to fill it out for different project types
- [x] Write `book/core-concepts/todo-md.md` — cover the `[ ]`/`[~]`/`[x]` convention, agent collision prevention, and how populate works
- [x] Write `book/core-concepts/ops-sh.md` — explain the single-entry-point philosophy, walk through each command block, show how to add custom commands
- [x] Write `book/core-concepts/docs.md` — cover the docs convention, SUMMARY.md, when to write docs, the Feynman clarity pass
- [x] Write `book/skills/how-skills-work.md` — explain reference vs task skills, SKILL.md frontmatter, arguments, file structure
- [x] Write `book/skills/vibestack.md` — deep dive on what `/vibestack` does: project analysis, CLAUDE.md population, ops.sh configuration, doc seeding, TODO seeding
- [x] Write `book/skills/todo.md` — cover `/todo` (run mode) and `/todo populate` (populate mode), prioritization framework, task format
- [x] Write `book/skills/squad.md` — explain domain identification, rule generation, specialist subagents, manifest file, refresh workflow
- [x] Write `book/skills/docs.md` — cover `/docs` skill: context gathering, doc capture, cleanup pass, Feynman clarity pass
- [x] Write `book/skills/bosskey.md` — explain the standup generator: git analysis, tone rules, translation guide, output formats
- [x] Write `book/skills/reference-skills.md` — document cli-first (CLI over dashboards, env vars) and lsp (language server integration)
- [x] Write `book/skills/custom-skills.md` — guide for creating new skills: when to write one, frontmatter options, examples, personal vs project scope
- [x] Write `book/workflows/full-loop.md` — end-to-end walkthrough of a vibestack session from install to shipping code
- [x] Write `book/workflows/solo-developer.md` — patterns for solo devs: fast iteration, using TODO as a roadmap, keeping docs for future-you
- [x] Write `book/workflows/team-collaboration.md` — multi-developer patterns: agent collision prevention, shared CLAUDE.md, squad for domain ownership
- [x] Write `book/advanced/squad-mode.md` — deep dive: when to use it, domain identification heuristics, rules vs subagents, refresh workflow
- [x] Write `book/advanced/ci-guards.md` — cover the CI workflow templates: lint, coverage, security scanning for Node/Python/Rust/Go
- [x] Write `book/advanced/settings-and-hooks.md` — document settings.json (permissions, env, statusLine) and hooks (notify-done, statusline)
- [x] Write `book/advanced/tips.md` — common pitfalls, debugging tips, FAQ, performance tips for large codebases
