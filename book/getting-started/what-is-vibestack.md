# What is vibestack?

You open Claude Code in your project, ask it to add a feature, and it starts guessing. It doesn't know your project conventions. It doesn't know how you deploy. It doesn't know which tests to run or where your docs live. So it invents things — wrong file names, made-up commands, patterns that don't match your codebase.

vibestack fixes this by giving your AI agent a shared understanding of your project before it writes a single line of code.

## The Problem

AI coding agents are powerful, but they work in the dark. Every new conversation starts from zero. The agent has to re-discover your project structure, your build system, your conventions, your deployment process. It gets some of it right and some of it wrong, and you spend time correcting mistakes that shouldn't have happened.

This gets worse as projects grow. A 50-file codebase is navigable. A 500-file codebase with multiple services, shared types, and domain-specific conventions? The agent is going to guess, and it's going to guess wrong.

## The Solution

vibestack drops a small set of convention files into your project:

| File | What it does |
|------|-------------|
| `CLAUDE.md` | A quick-reference guide that tells the agent what the project is, how it's built, and what conventions to follow |
| `TODO.md` | A task tracker designed for human/AI collaboration, with built-in collision prevention for parallel agents |
| `ops.sh` | A single CLI entry point for every operation — build, test, run, deploy. One place to look, one way to do things |
| `docs/` | A living documentation folder that agents read before starting work and update as they learn |
| `.claude/skills/` | Reusable skills that teach the agent project-specific workflows and conventions |

These files aren't just documentation. They're structured context that Claude Code reads automatically. When you ask Claude to add a feature, it already knows your tech stack, your file structure, your testing patterns, and your deployment process.

## Four Design Opinions

vibestack is opinionated. These opinions exist because they solve real friction points in AI-assisted development.

### 1. Bypass Permissions

By default, Claude Code asks for permission before running commands, writing files, or making network requests. This is safe, but it breaks your flow. You end up approving the same actions dozens of times per session.

vibestack pre-approves common tool access in `.claude/settings.json` — file reads, writes, edits, searches, bash commands, and web fetches. Claude can work autonomously without stopping to ask "can I read this file?" every thirty seconds.

### 2. Squad Mode

Large codebases have different conventions in different areas. Your auth middleware has different rules than your React components. Your database layer has different patterns than your API routes.

Squad mode partitions your codebase into logical domains, each with its own rules file. When Claude works on files in a domain, the right context loads automatically. For complex domains, you can create specialist subagents with focused expertise and restricted tools.

### 3. CI Over Gates

Instead of interactive approval flows ("should I run this test?", "can I lint this file?"), vibestack favors automated validation. Run the tests. Run the linter. Check the types. If something fails, fix it. Don't ask — verify.

This keeps the agent moving forward instead of waiting for you to click "approve" on routine checks.

### 4. Finish Notification

AI agents can take minutes to complete complex tasks. Sitting and watching a terminal is a waste of your time. vibestack includes hooks that play an audio alert when Claude finishes a task, so you can context-switch to other work and come back when it's done.

## What vibestack is NOT

- **Not a framework.** It doesn't ship runtime code. There's nothing to import, no dependencies to install, no binary to run.
- **Not a lock-in.** Every file it creates is plain Markdown or Bash. You can modify, extend, or delete any of it. If you stop using vibestack, your project still works exactly the same.
- **Not just for Claude Code.** The conventions (CLAUDE.md, structured docs, single CLI entry point) are useful patterns regardless of which AI tool you use. The skills are Claude Code-specific, but everything else is universal.

## How It Works in Practice

The workflow looks like this:

1. Install vibestack into your project (one command)
2. Run `/vibestack` — Claude analyzes your project and fills in the convention files with real, project-specific content
3. Run `/todo populate` — Claude audits your codebase and creates a prioritized task list
4. Run `/todo` — Claude works through the tasks, one by one
5. Run `/docs` — Claude captures what it learned into your docs folder

From that point on, every Claude Code session in your project starts with full context. No more guessing.
