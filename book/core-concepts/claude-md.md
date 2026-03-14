# CLAUDE.md — The Project Brain

`CLAUDE.md` is the first file Claude Code reads when it enters your project. It's a quick-reference guide that tells the agent what the project is, how it's built, and what rules to follow. Think of it as the briefing document you'd give a new team member on day one.

Claude Code loads this file automatically at the start of every session. You don't need to tell it to read `CLAUDE.md` — it just does.

## Why It Matters

Without `CLAUDE.md`, Claude starts every conversation blind. It has to figure out your tech stack from package files, guess your conventions from code patterns, and hope it gets your project structure right. Sometimes it does. Often it doesn't.

With `CLAUDE.md`, Claude starts with the answers. It knows your build command, your test framework, your directory layout, and your coding style before it touches a single file.

## Sections

### Project Overview

One paragraph. What does this project do, what's the core technology, and how is it deployed.

```markdown
## Project Overview

Acme API is a REST service that handles order processing for an e-commerce platform.
Built with Go and PostgreSQL, deployed to AWS ECS via GitHub Actions. Serves ~10k
requests/minute in production.
```

Keep it short. This gives Claude the big picture so it can reason about how changes fit into the whole system.

### Tech Stack

A bullet list of everything that matters: language, framework, key dependencies, database, infrastructure.

```markdown
## Tech Stack

- Go 1.22
- Chi router
- PostgreSQL 15 (via pgx)
- Redis for session caching
- AWS ECS (Fargate) + RDS
- GitHub Actions for CI/CD
```

This prevents Claude from suggesting the wrong tools. If it knows you use Chi, it won't suggest Gin patterns. If it knows you're on PostgreSQL, it won't write MySQL syntax.

### Commands

Points to `ops.sh` as the single way to do things. This section stays the same across all vibestack projects — it describes the convention, not project-specific commands.

### Project Structure

A directory tree showing the top-level layout. Only include directories that matter — don't list every file.

```markdown
## Project Structure

```
cmd/api/          # Application entry point
internal/
  handler/        # HTTP handlers
  service/        # Business logic
  repo/           # Database access
  model/          # Domain types
migrations/       # SQL migration files
docs/             # Living documentation
ops.sh            # Project CLI
```

This tells Claude where to find things. When you ask it to "add a new endpoint," it knows to look in `handler/` for the HTTP layer and `service/` for the business logic.

### Architecture

How the key components connect. Be concise — link to `docs/` for deep dives.

```markdown
## Architecture

HTTP requests hit Chi handlers in `internal/handler/`, which call service
functions in `internal/service/`. Services use repositories in `internal/repo/`
for database access. All SQL uses pgx — no ORM. Migrations run via golang-migrate.
```

### Key Workflows

This section describes vibestack conventions (docs, TODO, skills) and stays the same across projects. Don't modify it unless you've customized the conventions.

### External Services

Lists the third-party services your project talks to and how credentials are managed.

```markdown
## External Services

- AWS (ECS, RDS, S3) — credentials via `aws` CLI profile
- Stripe — API key in `.env.local` as `STRIPE_SECRET_KEY`
- SendGrid — API key in `.env.local` as `SENDGRID_API_KEY`
```

### Conventions

Project-specific rules that Claude should follow. Naming patterns, commit style, testing approach, error handling conventions — anything that's not obvious from the code.

```markdown
## Conventions

- All handler functions return `(response, error)` — never write to `w` directly
- Table-driven tests for all handler and service functions
- Errors wrap with `fmt.Errorf("functionName: %w", err)` — always include the function name
- Commit messages follow Conventional Commits: `feat:`, `fix:`, `test:`, `docs:`
- No exported functions without a doc comment
```

This is where vibestack pays for itself. These rules are the kind of thing that takes Claude multiple corrections to learn — but if they're written here, it gets them right the first time.

## Filling It Out

### Let `/vibestack` do the first pass

When you run [`/vibestack`](../skills/vibestack.md), Claude analyzes your project and fills in every section based on what it finds. This gets you 80% of the way there.

### Then refine manually

Review what Claude wrote and fix anything that's off:

- Is the project overview accurate?
- Are there dependencies or services it missed?
- Are the conventions it inferred actually the ones you follow?
- Is the architecture description correct?

The 20% you refine manually is the most valuable part — it's the stuff that's not obvious from code alone.

## Tips

- **Keep it under 100 lines.** CLAUDE.md is loaded into every conversation. Long files waste context. Move detailed explanations to `docs/` and link to them.
- **Update it when things change.** If you switch from REST to GraphQL, update the overview. If you add a new service, add it to external services. Stale context is worse than no context.
- **Be specific.** "Follow best practices" tells Claude nothing. "Errors wrap with `fmt.Errorf("functionName: %w", err)`" tells it exactly what to do.
- **Don't duplicate docs.** CLAUDE.md is a quick reference. If a topic needs more than a few sentences, write a doc and link to it.
