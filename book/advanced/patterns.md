# Common Patterns

Recipes for situations that come up regularly when using vibestack.

## Monorepos

A monorepo has multiple packages or services in one repository. vibestack handles this with squad mode.

**Setup:**

1. Put `CLAUDE.md` at the repo root with project-wide conventions
2. Run `/squad` to generate domain-specific rules for each package
3. Each package gets its own rule file at `.claude/rules/<package>.md`

```
monorepo/
  CLAUDE.md              # Global: repo structure, shared conventions
  .claude/
    rules/
      frontend.md        # React patterns, component conventions
      api.md             # Express patterns, route conventions
      shared.md          # Shared types and utilities
  packages/
    frontend/
    api/
    shared/
```

**ops.sh** should support targeting specific packages:

```bash
elif [[ "$cmd" == "test" ]]; then
    TARGET="${1:-all}"
    if [[ "$TARGET" == "all" ]]; then
        pnpm -r test
    else
        pnpm --filter "$TARGET" test
    fi
```

## Migrating from an Existing CLAUDE.md

If your project already has a `CLAUDE.md` before installing vibestack, the installer won't overwrite it. To adopt vibestack conventions:

1. Install vibestack normally — it merges with your existing files
2. Run `/vibestack` — Claude reads your existing CLAUDE.md and adds the vibestack sections (Commands, Key Workflows, Skills) while preserving your content
3. Review the merged result — make sure nothing was lost or duplicated

If you'd rather start fresh, rename your existing file first:

```bash
mv CLAUDE.md CLAUDE.md.backup
curl -fsSL https://raw.githubusercontent.com/vibestackmd/vibestack/main/install.sh | bash
# Then run /vibestack to populate from scratch
# Copy any custom content from CLAUDE.md.backup into the new file
```

## Onboarding a New Team Member

When someone new joins a project that uses vibestack:

1. They clone the repo — all convention files come with it
2. They run `claw` — Claude Code loads CLAUDE.md automatically
3. They read `docs/` — or just start working and let Claude read it for them
4. They run `/todo` — Claude works through tasks using the project's conventions

No setup guide needed. No "ask Sarah how to deploy." The conventions are in the repo.

**For AI agents specifically:** A new Claude session starts with full context on the first message. CLAUDE.md tells it the tech stack. Squad rules tell it domain conventions. docs/ tells it institutional knowledge. This is the main value proposition — context doesn't leave when a conversation ends.

## Splitting a Large TODO.md

When TODO.md grows past 20 items, it gets noisy. Two approaches:

**By priority tier:**

```markdown
## Critical (do first)
- [ ] Fix auth bypass in admin routes

## Important (do next)
- [ ] Add rate limiting to public API

## Nice to have (do later)
- [ ] Improve error messages on 404 pages
```

**By domain (for teams):**

Create separate TODO files per area:

```
TODO.md              # Main list, cross-cutting tasks
TODO-frontend.md     # Frontend-specific tasks
TODO-api.md          # API-specific tasks
```

Adjust `/todo` invocations to specify which file, or keep everything in one file and use domain labels.

## Converting ops.sh for Windows

`ops.sh` is Bash, which works on macOS, Linux, and WSL. For native Windows support, create a parallel `ops.ps1`:

```powershell
param([string]$Command = "help")

switch ($Command) {
    "build" { npm run build }
    "test"  { npm test }
    "run"   { npm run dev }
    "help"  { Write-Host "Usage: .\ops.ps1 <command>" }
}
```

Or just use WSL — most Windows developers using Claude Code already have it.

## Keeping CLAUDE.md Under 100 Lines

CLAUDE.md loads into every conversation. If it's too long, it wastes context on information Claude doesn't need for the current task.

**Move to docs/:**
- Detailed architecture explanations
- Full deployment runbooks
- Long lists of conventions
- Historical context or decision logs

**Keep in CLAUDE.md:**
- Project overview (1 paragraph)
- Tech stack (bullet list)
- Directory structure (tree, top-level only)
- Architecture (1 paragraph + link to docs/)
- Key conventions (5-10 bullets)
- External services (which ones, where credentials live)

Link from CLAUDE.md to docs/ for anything that needs more than a few sentences.

## Running vibestack in CI

You can use vibestack skills in CI pipelines by running Claude Code in non-interactive mode. This is useful for automated doc updates or task generation:

```yaml
- name: Update docs
  run: |
    echo "/docs" | claude --no-interactive
```

This is experimental — most teams use vibestack interactively and reserve CI for standard checks (lint, test, build).
