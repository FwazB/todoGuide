# Squad Mode Deep Dive

Squad mode partitions your codebase into logical domains, each with its own context that Claude loads automatically. This chapter goes deeper than the [/squad skill overview](../skills/squad.md) — it covers when to use squad mode, how to identify good domains, and how to tune the generated rules.

## When to Use Squad Mode

Squad mode adds value when your codebase is large enough that different areas have genuinely different conventions. A good rule of thumb:

- **Under 50 files:** You probably don't need squad mode. CLAUDE.md covers everything.
- **50-200 files:** Squad mode starts to help if you have distinct areas (frontend/backend, multiple services, separate data layer).
- **200+ files:** Squad mode is strongly recommended. Claude can't hold the conventions for a large codebase in one context.

If you run `/squad` and it identifies fewer than 3 domains, your project isn't ready for it yet. That's fine — come back when it grows.

## How Domains Are Identified

`/squad` uses several signals to group files into domains:

### Feature Clusters

Files that work together to deliver a feature. Auth routes, auth middleware, auth models, and auth tests all belong to the "auth" domain even though they live in different directories.

```
src/routes/auth.ts        ┐
src/middleware/auth.ts     │ → "auth" domain
src/models/user.ts         │
src/services/auth.ts       │
tests/auth/               ┘
```

### Layer Boundaries

Horizontal layers like "data layer," "API surface," or "UI components." These make good domains when they have distinct conventions — if the data layer uses raw SQL while the API layer uses a framework, that's a meaningful boundary.

### Infrastructure vs Product

CI/CD configs, Docker files, deployment scripts, and build tooling are often their own domain. They have different conventions (YAML formatting, shell scripting style) and different risk profiles.

### Cross-Cutting Concerns

Logging, error handling, and shared utilities can form a domain if they have specific conventions. A project-wide error handling pattern that every file must follow is worth documenting as its own domain.

## What Makes a Good Domain

Three criteria:

1. **Specific conventions** that differ from the project defaults. If a domain follows the same rules as everything else, a rule file adds no value.
2. **Enough files** to warrant its own context. A domain with 2 files isn't worth the overhead.
3. **A clear identity.** You can name it in 1-2 words and someone knows what it covers.

### Bad Domains

- "Utilities" — too vague, probably just a few helper files
- "src" — that's just your whole project
- "Tests" — tests usually follow the conventions of the code they test

### Good Domains

- "Auth" — clear identity, specific conventions (token handling, session management)
- "Data Layer" — specific patterns (query building, migration rules, transaction handling)
- "API" — specific conventions (route naming, middleware ordering, error response format)

## Rules vs Subagents

For each domain, `/squad` generates a **rule file**. For some domains, it also generates a **specialist subagent**. They serve different purposes.

### Rule Files (`.claude/rules/<domain>.md`)

Auto-loaded when Claude works on files matching the glob patterns. Lightweight — they add context without changing Claude's behavior.

```markdown
---
paths:
  - "src/auth/**/*"
  - "src/middleware/auth*.ts"
  - "tests/auth/**/*"
---

# Auth Domain

Handles authentication and session management.

## Conventions

- All tokens are JWT stored in httpOnly cookies, never localStorage
- Session duration is 24 hours, refresh tokens last 7 days
- Password hashing uses bcrypt with cost factor 12
- Auth middleware runs before all /api/ routes except /api/health

## Interfaces

- Connects to: data-layer (user sessions), api (route handlers)
- Shared types: `src/types/auth.ts`
```

Use rules for most domains. They're simple, automatic, and low-overhead.

### Specialist Subagents (`.claude/agents/<domain>-specialist.md`)

A focused Claude session with restricted tools and specialized knowledge. Only generate these when:

- The domain has **complex, specialized knowledge** (database migrations, complex build system)
- Getting it wrong has **high consequences** (security, data integrity)
- A focused specialist with **restricted tools** would be safer

```markdown
---
name: data-specialist
description: Delegate to this specialist when working on database migrations or query changes.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a database specialist for this project.

When working with migrations:
1. Always check existing migration history before creating new ones
2. Verify backward compatibility — can the previous app version run against the new schema?
3. Test rollback before marking done
```

Most domains should get rules only. Subagents are the exception, not the default.

## The Manifest

`/squad` creates `.claude/squad.json` to track what it generated:

```json
{
  "generated": "2026-03-14",
  "domains": {
    "auth": {
      "description": "Authentication, sessions, and access control",
      "patterns": ["src/auth/**/*", "src/middleware/auth*.ts", "tests/auth/**/*"],
      "ruleFile": ".claude/rules/auth.md",
      "agentFile": null,
      "fileCount": 18
    },
    "data-layer": {
      "description": "Database access, migrations, and query patterns",
      "patterns": ["src/repo/**/*", "src/models/**/*", "migrations/**/*"],
      "ruleFile": ".claude/rules/data-layer.md",
      "agentFile": ".claude/agents/data-specialist.md",
      "fileCount": 32
    }
  },
  "unmapped": ["scripts/**", "tools/**"]
}
```

The `unmapped` field lists files that didn't clearly belong to any domain. Review these — they might belong to an existing domain (update the patterns) or warrant a new one.

## Refreshing

When your project structure changes — new directories, renamed modules, added services — run:

```
/squad refresh
```

This re-analyzes the codebase and updates existing squad config:

- Adds new domains if new areas have emerged
- Updates glob patterns for existing domains if files moved
- Removes domains whose files no longer exist
- **Preserves your manual edits** to rule files — it only updates the `paths:` frontmatter and adds notes about new files

## Tuning Rules

The auto-generated rules are a starting point. Spend 10 minutes refining them:

- **Remove generic advice.** "Follow best practices" wastes context. Keep only rules specific to this domain.
- **Add the gotchas.** The non-obvious things that trip people up. "The ORM silently drops columns that aren't in the model — always check the generated SQL."
- **Reference actual code.** "See `src/auth/middleware.ts:42` for the token validation flow" is more useful than "validate tokens properly."
- **Document interfaces.** Which other domains does this one connect to? Where are the shared types? This helps Claude navigate cross-domain changes.
