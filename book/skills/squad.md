# /squad -- Domain Specialists

`/squad` partitions your codebase into logical domains and generates context that loads automatically when Claude works on files in each area. Instead of Claude treating every file the same way, it gets domain-specific conventions, patterns, and gotchas for the part of the code it's currently touching.

This matters in medium-to-large codebases where different areas have different rules. Your auth layer has different conventions than your UI components. Your database migrations follow different patterns than your API routes. Squad teaches Claude those differences.

## What It Does

When you run `/squad`, Claude walks through a structured analysis:

### 1. Scans the Project

Claude builds a mental map of the codebase by reading:

- The full directory structure (ignoring `node_modules`, `.git`, `dist`, `build`, and similar)
- Entry point files (`index.ts`, `main.py`, `app.ts`, `server.ts`, `cmd/`)
- Config files (`package.json`, `tsconfig.json`, `go.mod`, `Cargo.toml`)
- Import statements across the codebase to understand which files reference each other
- Shared type definitions, schemas, and interfaces that define boundaries between areas

### 2. Identifies Domains

Claude groups the codebase into 3-8 logical domains. It looks for natural boundaries:

- **Feature clusters** -- Files that work together to deliver a capability. Auth routes, auth middleware, auth models, and auth tests all form an "auth" domain.
- **Layer boundaries** -- Horizontal layers like "data layer", "API surface", or "UI components" -- but only when they have distinct conventions worth documenting.
- **Infrastructure vs product** -- CI/CD pipelines, deployment configs, and build tooling often have their own patterns that differ from application code.
- **Cross-cutting concerns** -- Logging, error handling, and shared utilities may form a domain if they follow specific conventions.

Not everything needs to be a domain. Claude aims for the sweet spot:

- **Fewer than 3 domains** means the project probably doesn't need squad yet. Claude tells you and stops.
- **More than 8 domains** means the slicing is too thin. Better to have 5 well-defined domains than 10 shallow ones.

### What Makes a Good Domain

A domain earns its place when it has all three of these:

- **Specific conventions** that differ from the project defaults. If the files follow the same rules as everything else, a separate rule file adds no value.
- **Enough files** to warrant its own context. A domain with 2 files isn't worth the overhead.
- **Clear identity** -- you can name it in 1-2 words and someone immediately knows what it covers. "auth", "data-layer", "infra", "ui".

### 3. Generates Path-Specific Rules

For each domain, Claude creates a rule file at `.claude/rules/<domain>.md`:

```markdown
---
paths:
  - "src/auth/**/*"
  - "src/middleware/auth*.ts"
  - "tests/auth/**/*"
---

# Auth Domain

Handles user authentication, session management, and authorization checks.

## Conventions

- All auth tokens are JWT in httpOnly cookies -- never localStorage
- Session validation middleware runs on every /api/ route except /api/auth/login and /api/auth/register
- Password hashing uses bcrypt with cost factor 12
- Failed login attempts are rate-limited per IP in src/middleware/rateLimit.ts
- Auth errors return 401 with a generic message -- never reveal whether the email exists

## Interfaces

- Connects to: data-layer (user sessions table), api (route handlers)
- Shared types: src/types/auth.ts
```

The `paths` frontmatter is the key mechanism. When Claude later opens a file matching one of those glob patterns, the rule file loads automatically. No manual invocation needed. Claude just knows the auth conventions when it's working on auth files.

Rules follow these principles:

- Only domain-specific conventions go here. Global project rules stay in CLAUDE.md.
- Be concrete: "use bcrypt with cost factor 12" not "follow security best practices."
- Include actual file paths and function names at key integration points.
- Glob patterns should be generous enough to catch related test files, type definitions, and config -- not just source files.

### 4. Generates Specialist Subagents (Selective)

Most domains only need rules. But some domains are complex enough or high-stakes enough to warrant a dedicated subagent -- a focused specialist with its own persona and restricted tools.

Claude generates a subagent only when a domain meets all of these criteria:

- The domain has complex, specialized knowledge (database migrations, complex build systems)
- Getting it wrong has high consequences (security, data integrity)
- A focused specialist with restricted tools would be safer than the general agent

For qualifying domains, Claude creates `.claude/agents/<domain>-specialist.md`:

```markdown
---
name: data-specialist
description: Specialist for database schema changes, migrations, and query optimization. Use proactively when working on data-layer files.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a database specialist for this project.

The database is PostgreSQL 15 accessed via Prisma ORM. All schema changes
go through Prisma migrations -- never modify the database directly.

When working in this domain:
1. Read the current schema in prisma/schema.prisma before making changes
2. Check for existing migrations that might conflict in prisma/migrations/
3. After schema changes, run `npx prisma migrate dev` to generate the migration
4. Verify the migration SQL is safe -- no data loss, no locking issues on large tables
5. Update seed data in prisma/seed.ts if the schema change affects it
```

Subagents use a smaller model (`sonnet`) and restricted tools for efficiency and safety. The general agent delegates to them when working on files in the domain.

Most projects end up with rules for every domain and subagents for zero or one. That's normal. Don't force subagents where rules are sufficient.

### 5. Writes the Manifest

Claude creates or updates `.claude/squad.json` to track the squad configuration:

```json
{
  "generated": "2025-09-15",
  "domains": {
    "auth": {
      "description": "Authentication, sessions, and authorization",
      "patterns": ["src/auth/**/*", "src/middleware/auth*.ts", "tests/auth/**/*"],
      "ruleFile": ".claude/rules/auth.md",
      "agentFile": null,
      "fileCount": 23
    },
    "data-layer": {
      "description": "Database schema, migrations, and data access",
      "patterns": ["prisma/**/*", "src/db/**/*", "tests/db/**/*"],
      "ruleFile": ".claude/rules/data-layer.md",
      "agentFile": ".claude/agents/data-specialist.md",
      "fileCount": 15
    },
    "api": {
      "description": "REST API routes and request handling",
      "patterns": ["src/routes/**/*", "src/handlers/**/*", "tests/api/**/*"],
      "ruleFile": ".claude/rules/api.md",
      "agentFile": null,
      "fileCount": 34
    }
  },
  "unmapped": ["scripts/**/*", "docs/**/*"]
}
```

The `unmapped` field lists file patterns that didn't clearly belong to any domain. This is intentional -- it's better to leave files unmapped than to guess wrong. On a future `/squad refresh`, you or Claude can decide where they belong.

## /squad refresh

When your project structure changes -- new feature areas, reorganized directories, added services -- run:

```
/squad refresh
```

Claude re-analyzes the codebase and updates the existing squad configuration:

- Adds new domains if new areas of the code have emerged
- Updates glob patterns if files have moved
- Removes domains whose files no longer exist
- Adds notes about new discoveries to existing rule files
- **Preserves your manual edits** -- if you've customized a rule file's conventions, Claude updates the `paths` frontmatter and adds new information but does not overwrite your hand-written rules

This is the key difference from running `/squad` from scratch. A fresh run generates everything new. A refresh respects what you've already tuned.

## When to Use Squad

Squad adds value when your project has:

- **Multiple distinct areas** with different conventions (auth layer uses different patterns than the API layer)
- **Enough code** that Claude can't hold the whole codebase in context at once
- **Non-obvious rules** that vary by area -- the kind of knowledge that causes mistakes when you don't have it

Squad is overkill for:

- Small projects where everything follows the same conventions
- Projects with fewer than ~20 source files
- Codebases where CLAUDE.md already captures all the important conventions

If you're unsure, run `/squad` and see what Claude finds. If it identifies fewer than 3 meaningful domains, it will tell you the project doesn't need squads yet.

## Tips

- **Start with rules, add subagents later.** Rules load automatically and are lightweight. Only add subagents if you find Claude making repeated mistakes in a domain that has high consequences.
- **Review the generated rules.** Claude's first pass is a starting point. The conventions it infers are usually directionally correct, but you'll catch things it missed or got wrong.
- **Keep domains broad.** "auth" is a better domain than "auth-middleware" and "auth-routes" as separate domains. You can always split later if needed.
- **Run `/squad refresh` after major refactors.** If you reorganize your directory structure or add a new major feature area, refresh keeps the squad config in sync.
- **Check `unmapped` in the manifest.** Those files might belong to an existing domain (update the glob pattern) or they might indicate a new domain worth defining.
