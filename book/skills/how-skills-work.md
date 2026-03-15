# How Skills Work

Every time you correct Claude — "no, we use Zod not Joi," "run pnpm not npm," "errors go through AppError" — that's a convention you could write down once and never repeat. Skills are how you do that. They're Markdown files that teach Claude your project's rules and workflows, loaded automatically or on demand. No plugins, no APIs, no build steps.

## Two Types of Skills

Skills come in two flavors, and the distinction matters.

### Reference Skills

Reference skills are context that Claude loads automatically when relevant. They define conventions — how to handle external services, how to use language servers, how to format error messages. You never invoke them directly. They just show up in Claude's context when it needs them.

Reference skills set `user-invocable: false` in their frontmatter:

```yaml
---
name: cli-first
description: Use CLI tools and .env* files for third-party services
user-invocable: false
---
```

When Claude works on something that matches the skill's description, it loads the skill's content as additional context. You don't type a command. You don't trigger it manually. It's always there when relevant.

Examples from vibestack:
- **cli-first** — Use CLI tools instead of web dashboards for external services
- **lsp** — Use language servers for type checking, references, and code navigation

### Task Skills

Task skills are slash commands you invoke explicitly. They define multi-step workflows — setting up a project, running through a task list, analyzing the codebase. You trigger them by typing `/skillname` in a Claude Code session.

Task skills set `disable-model-invocation: true` in their frontmatter, which means Claude won't run them on its own. You have to ask for it:

```yaml
---
name: todo
description: Work through TODO.md tasks sequentially
user-invocable: true
disable-model-invocation: true
argument-hint: "[number-of-tasks] or populate"
---
```

You invoke a task skill like this:

```
/todo
/todo 3
/todo populate
/vibestack
/squad refresh
```

Examples from vibestack:
- **/vibestack** — Set up all convention files for a project
- **/todo** — Work through or populate the task list
- **/squad** — Generate domain-specific rules and specialist subagents
- **/docs** — Capture learnings into docs

## File Structure

Every skill lives in its own directory under `.claude/skills/`:

```
.claude/skills/
  my-skill/
    SKILL.md          # Required — the skill definition
    reference.md      # Optional — additional context loaded alongside SKILL.md
    templates/        # Optional — template files the skill can reference
      component.tsx
      test.ts
```

`SKILL.md` is the only required file. It contains the frontmatter and the instructions Claude follows. If your skill needs to reference additional material — long examples, boilerplate templates, detailed specifications — put those in `reference.md` or a `templates/` directory alongside it.

## SKILL.md Frontmatter

The frontmatter at the top of `SKILL.md` controls how the skill behaves. Here are the fields:

```yaml
---
name: my-skill
description: What this skill does — Claude uses this to decide when to load reference skills
user-invocable: true
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash, Edit, Write
argument-hint: "[target] or refresh"
context:
  - reference.md
  - templates/component.tsx
---
```

| Field | Purpose |
|-------|---------|
| `name` | The skill's identifier. For task skills, this is the slash command name. |
| `description` | What the skill does. Claude uses this to match reference skills to the current task. |
| `user-invocable` | Set `true` for task skills (slash commands), `false` for reference skills. |
| `disable-model-invocation` | Set `true` to prevent Claude from running this skill on its own. Use for task skills. |
| `allowed-tools` | Restricts which tools the skill can use. Omit to allow all tools. |
| `argument-hint` | Shown in autocomplete to hint at what arguments the skill accepts. |
| `context` | List of additional files to load when the skill is invoked. Paths are relative to the skill directory. |

## Arguments

Task skills can accept arguments. When you type `/todo 3` or `/squad refresh`, everything after the skill name is passed as arguments.

Inside the skill's instructions, you access arguments with these variables:

| Variable | Value for `/todo 3 items` |
|----------|--------------------------|
| `$ARGUMENTS` | `3 items` (the full argument string) |
| `$0` | `3` (first positional argument) |
| `$1` | `items` (second positional argument) |
| `$2` | (empty — no third argument) |

Here's how a skill uses arguments in practice:

```markdown
If `$ARGUMENTS` is `populate`, jump to the **Populate** section.
Otherwise, treat `$0` as the maximum number of tasks to work on.
If `$ARGUMENTS` is empty, work through all uncompleted tasks.
```

## Where Skills Live

Skills can live in two places:

### Project Skills

```
your-project/.claude/skills/
```

These are checked into your repo and shared with the team. Every collaborator (human or AI) gets the same skills when they work on the project.

### Personal Skills

```
~/.claude/skills/
```

These live in your home directory and apply to every project you work on. Use these for personal workflows that aren't specific to any one codebase — your preferred commit style, your code review checklist, your debugging approach.

**If a personal skill has the same name as a project skill, the personal skill takes precedence.** This lets you override project defaults with your own preferences without modifying the shared config.

## Putting It Together

A minimal reference skill looks like this:

```
.claude/skills/
  my-convention/
    SKILL.md
```

```yaml
---
name: my-convention
description: Error handling conventions for this project
user-invocable: false
---

# Error Handling

All errors in this project use the AppError class from `src/lib/errors.ts`.

- Throw `AppError` with a status code and user-facing message
- Never expose stack traces to the client
- Log the full error with stack trace server-side via `logger.error()`
- Wrap external service errors in AppError before re-throwing
```

A minimal task skill looks like this:

```
.claude/skills/
  seed-data/
    SKILL.md
```

```yaml
---
name: seed-data
description: Generate realistic seed data for the development database
user-invocable: true
disable-model-invocation: true
---

# Seed Data Generator

Generate seed data for the development database.

## Steps

1. Read the schema from `prisma/schema.prisma`
2. For each model, generate 10-20 realistic records
3. Write the seed script to `prisma/seed.ts`
4. Run `npx prisma db seed` to load the data
5. Verify the data loaded correctly with a count query
```

That's all there is to it. Skills are just Markdown files with a bit of structure. The power comes from what you write inside them.
