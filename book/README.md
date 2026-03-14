# The vibestack Guide

> Give your AI agents the context to build, not guess.

vibestack is an opinionated convention framework for AI-assisted development. It drops a set of files into your project -- `CLAUDE.md`, `TODO.md`, `ops.sh`, `docs/`, and `.claude/skills/` -- that give Claude Code (and you) a shared understanding of how to build, test, deploy, and document your project.

This book covers everything you need to go from zero to a fully AI-augmented development workflow.

## The Workflow at a Glance

```
Install           Configure         Work              Capture
   |                  |                |                  |
   v                  v                v                  v
curl ... | bash  →  /vibestack  →  /todo populate  →  /docs
                                   /todo
```

1. **Install** -- one command drops convention files into your project
2. **Configure** -- `/vibestack` analyzes your codebase and fills in the templates
3. **Work** -- `/todo populate` seeds a prioritized task list, `/todo` executes tasks
4. **Capture** -- `/docs` writes learnings into your docs folder

Repeat steps 3-4 as you build. Each cycle makes the next one smarter.

## Start Here

New to vibestack? Read these three chapters in order:

1. [What is vibestack?](getting-started/what-is-vibestack.md) -- the problem it solves and how
2. [Installation](getting-started/installation.md) -- get it running in under a minute
3. [Your First Run](getting-started/first-run.md) -- the full first-time walkthrough

Already using vibestack? Jump to the section you need:

- **[Core Concepts](core-concepts/claude-md.md)** -- deep dives on CLAUDE.md, TODO.md, ops.sh, and docs/
- **[Skills](skills/how-skills-work.md)** -- how to use and create skills
- **[Workflows](workflows/full-loop.md)** -- patterns for solo devs and teams
- **[Advanced](advanced/squad-mode.md)** -- squad mode, CI guards, settings, and tips

## Who This Is For

- Developers using Claude Code who want more structure and less guessing
- Teams adopting AI-assisted development and looking for repeatable conventions
- Anyone curious about how to make AI agents genuinely productive on real codebases

## What You'll Learn

- How to install vibestack and get it configured for your project in minutes
- The core files and what each one does
- How to use skills like `/todo`, `/squad`, `/docs`, and `/bosskey`
- How to create your own custom skills
- How to scale with squad mode for larger codebases
- Best practices for human/AI collaboration
