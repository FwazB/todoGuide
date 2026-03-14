# Glossary

Quick reference for vibestack terminology.

**CLAUDE.md** -- A Markdown file in the project root that Claude Code reads automatically at the start of every session. Contains the project overview, tech stack, structure, architecture, and coding conventions. Think of it as the briefing document for AI agents.

**CLI-first** -- A convention where CLI tools (like `aws`, `gh`, `vercel`) are preferred over web dashboards or raw API calls. Enforced by the `cli-first` reference skill.

**Domain** -- A logical area of the codebase with its own conventions. Examples: "auth," "data-layer," "api," "infra." Identified by `/squad` and documented in rule files.

**Hook** -- A shell command that runs in response to a Claude Code event. Defined in `.claude/settings.json`. The default vibestack hooks are `notify-done.sh` (plays a sound when Claude finishes) and `statusline.sh` (shows project state in the status bar).

**LSP** -- Language Server Protocol. A standard that lets editors and tools understand code semantically -- finding references, checking types, jumping to definitions. The `lsp` reference skill tells Claude to use LSP tools instead of guessing from grep results.

**ops.sh** -- A Bash script that serves as the single entry point for all project operations: build, test, run, deploy, and more. Both humans and Claude use it as the "how do I do anything" reference.

**Pending marker** -- The `[~]` checkbox state in TODO.md. When Claude starts working on a task, it marks it `[~]` before doing any work. This signals to parallel agents that the task is taken, preventing collisions.

**Populate** -- The mode of `/todo` that scans the codebase and generates a fresh batch of 10-20 prioritized tasks. Invoked with `/todo populate`.

**Reference skill** -- A skill that Claude loads automatically when the topic is relevant. Not a slash command. Used for conventions and patterns (e.g., `cli-first`, `lsp`). Set with `user-invocable: false` in frontmatter.

**Rule file** -- A Markdown file at `.claude/rules/<domain>.md` with `paths:` frontmatter. When Claude works on files matching the glob patterns, the rule file loads automatically, providing domain-specific conventions.

**Settings.json** -- The project-level Claude Code configuration file at `.claude/settings.json`. Controls permissions, environment variables, hooks, and the status line.

**Skill** -- A Markdown file that teaches Claude project-specific conventions or workflows. Lives at `.claude/skills/<name>/SKILL.md`. Two types: reference skills (auto-loaded) and task skills (slash commands).

**SKILL.md** -- The required file in a skill directory. Contains YAML frontmatter (name, description, settings) and Markdown instructions that Claude follows.

**Squad** -- The system of domain partitioning that gives Claude area-specific context. Created by `/squad`, which generates rule files, optional subagents, and a manifest (`squad.json`).

**Subagent** -- A specialist Claude session spawned for a specific domain. Has restricted tools and a focused persona. Created by `/squad` for high-stakes domains. Most projects use zero or one.

**Task skill** -- A skill invoked via slash command (e.g., `/todo`, `/vibestack`). Set with `user-invocable: true` and typically `disable-model-invocation: true` in frontmatter.

**TODO.md** -- A Markdown file with checkboxes that serves as a lightweight task tracker. Three states: `[ ]` (open), `[~]` (pending), `[x]` (done). Designed for human/AI collaboration with collision prevention.
