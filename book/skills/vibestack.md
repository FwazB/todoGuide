# /vibestack -- Project Setup

`/vibestack` is the setup command. It analyzes your project and configures all vibestack convention files -- CLAUDE.md, ops.sh, docs, and TODO.md -- with real content based on your actual codebase.

You run it once when you first adopt vibestack. After that, you only run it again if the project structure changes significantly (new major dependency, rewritten build system, migrated to a different framework).

## What It Does

When you type `/vibestack` in a Claude Code session, Claude walks through five steps in order. Each step builds on the information gathered in the previous one.

### Step 1: Project Analysis

Before touching any files, Claude reads everything it can find about your project:

- **Build and config files** -- `package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`, `Makefile`, `Dockerfile`, whatever exists. This reveals the language, framework, dependencies, and build toolchain.
- **Directory structure** -- How the code is organized. Where source files live, where tests live, where config lives.
- **Build, test, and deploy scripts** -- npm scripts, Makefile targets, CI workflow files (`.github/workflows/`, `.gitlab-ci.yml`), deployment configs (Vercel, Fly.io, AWS).
- **External services** -- Database config, API keys in `.env*` files, cloud provider references in config files, third-party SDK imports in the dependency list.
- **Existing documentation** -- README, docs folders, architecture notes, CHANGELOG, contributing guides.
- **Existing CLAUDE.md content** -- If you already have a CLAUDE.md with custom content, Claude preserves anything that's still accurate.

Claude doesn't guess. It reads your files and builds its understanding from what's actually there.

### Step 2: Fill Out CLAUDE.md

Claude takes the template CLAUDE.md (installed by vibestack) and fills in the project-specific sections:

- **Project Overview** -- One paragraph describing what the project does, the core technology, and how it's deployed.
- **Tech Stack** -- A bullet list of the language, framework, key dependencies, database, and infrastructure.
- **Project Structure** -- A directory tree showing the top-level layout with descriptions of what each directory contains.
- **Architecture** -- How the key components connect. Which layer calls which, how data flows, what the main abstractions are.
- **Conventions** -- Patterns Claude can infer from the code: naming conventions, test organization, error handling style, import ordering, commit message format.

The Commands, Key Workflows, and Skills sections stay as-is -- they describe vibestack conventions that don't change per project.

Here's an example of what the Tech Stack section looks like after `/vibestack` runs on a Next.js project:

```markdown
## Tech Stack

- TypeScript 5.3
- Next.js 14 (App Router)
- Prisma ORM with PostgreSQL
- NextAuth.js for authentication
- Tailwind CSS
- Vercel for deployment
- GitHub Actions for CI
```

### Step 3: Fill Out ops.sh

The template `ops.sh` has placeholder TODO comments where project-specific commands go. Claude replaces them with real commands:

- **build** -- Your actual build command (`npm run build`, `cargo build --release`, `go build ./cmd/api`)
- **test** -- Your actual test command (`npm test`, `pytest`, `cargo test`)
- **run** -- Your dev server command (`npm run dev`, `cargo run`, `python manage.py runserver`)
- **deploy** -- If Claude can determine the deploy target, it fills this in. Otherwise it leaves a TODO with a note about what it found.
- **logs**, **status** -- Same as deploy: filled in if determinable, left as TODO otherwise.
- **PROJECT_NAME** -- Set to the actual project name from your config files.

If your project has useful commands that aren't covered by the defaults -- `lint`, `migrate`, `seed`, `typecheck` -- Claude adds them as new commands following the existing pattern in the file.

Here's what the build section might look like after setup:

```bash
build)
    echo "Building $PROJECT_NAME..."
    npm run build
    ;;
```

### Step 4: Write Initial Docs

Claude creates starter documentation in `docs/` based on what it learned:

- **Updates `docs/index.md`** -- Replaces the placeholder with a real project description and links to key docs.
- **Creates architecture docs** -- But only if the project warrants it. A single-service app with three files doesn't need an architecture doc. A multi-service system with a message queue and three databases does.
- **Creates topical docs** -- If Claude found non-obvious integration patterns, deployment workflows, or complex subsystems, it documents them.
- **Updates `docs/SUMMARY.md`** -- Adds entries for any new docs it created.

Claude doesn't create docs just to have docs. Every file it writes should genuinely help a new contributor get up to speed faster.

### Step 5: Seed TODO.md

Claude replaces the example tasks with 10-20 real engineering tasks, ranked by impact. It thinks like a staff engineer driving toward production-readiness:

1. **Security and data integrity** -- Auth gaps, missing input validation, hardcoded secrets, injection vectors.
2. **Core reliability** -- Missing error handling, no database migrations, unsafe transactions.
3. **Testing** -- No tests for critical paths, missing integration tests, untested edge cases.
4. **CI/CD and deployment** -- No automated pipeline, no staging environment, manual deploy steps.
5. **Observability** -- No logging, no error tracking, no uptime monitoring.
6. **Performance** -- Missing database indexes, N+1 queries, no caching where it matters.
7. **User experience** -- Missing loading states, unhelpful error messages, broken mobile layouts.
8. **Developer experience** -- No linting, no type checking, painful dev setup.

Each task is specific and references actual files in your codebase:

```markdown
- [ ] Add input validation to `POST /api/users` in `src/routes/users.ts` -- validate email format, password length, and required fields
- [ ] Move Stripe API key from hardcoded value in `src/lib/stripe.ts` to environment variable
- [ ] Write integration tests for the checkout flow in `src/services/checkout.ts`
```

## When to Run It

Run `/vibestack` in these situations:

- **First time setup.** After installing vibestack into an existing project, `/vibestack` is the first thing you run.
- **Major structural changes.** If you migrate from JavaScript to TypeScript, switch from Express to Fastify, or reorganize your directory structure, run it again to update CLAUDE.md and ops.sh.
- **New project from scratch.** If you're starting a new project and have already scaffolded it with a framework CLI (`create-next-app`, `cargo init`, etc.), run `/vibestack` to configure the convention files.

Do not run it every session. It's a one-time setup command, not a recurring workflow. For ongoing task management, use `/todo`. For ongoing documentation, use `/docs`.

## After It Runs

When `/vibestack` finishes, it tells you:

- What it filled in with confidence
- What it left as TODOs because it couldn't determine the right values
- Recommendations for next steps

Review everything it wrote. The generated content is a starting point -- an 80% first pass. The 20% you refine is the most valuable part, because it's the knowledge that isn't obvious from code alone.

Pay particular attention to:

- **CLAUDE.md conventions** -- Did Claude infer the right patterns? Are there conventions your team follows that aren't visible in the code?
- **ops.sh deploy command** -- Claude often can't determine the full deploy flow. Fill in what it missed.
- **TODO.md priorities** -- The ranking is usually right, but you know your business priorities better than Claude does. Reorder if needed.
