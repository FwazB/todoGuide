# Your First Run

The convention files are in your project but they're all templates. This chapter walks you through the four commands that turn them into real, project-specific context: `/vibestack`, `/todo populate`, `/todo`, and `/docs`. By the end, Claude will know your project as well as you do.

## Launch Claude Code

Open your terminal in the project directory and start a session:

```bash
cd your-project
claw
```

You're now in Claude Code with vibestack's skills and settings loaded.

## Step 1: `/vibestack`

This is the setup command. Type it and hit enter:

```
/vibestack
```

Claude reads your entire project — build files, config, directory structure, dependencies, existing docs — and uses what it finds to fill in the convention templates.

Here's what it does:

1. **Fills out CLAUDE.md** — Writes a real project overview, tech stack, directory structure, architecture summary, and coding conventions based on your actual code.
2. **Configures ops.sh** — Replaces the placeholder commands with your real build, test, run, and deploy commands. If you use `npm run build`, that goes in. If you deploy with Vercel, that goes in.
3. **Creates starter docs** — Writes an `index.md` with a real project description. If your project has enough structure, it creates architecture docs too.
4. **Seeds TODO.md** — Replaces the example task with 10-20 real engineering tasks ranked by impact. Security issues first, then reliability, testing, CI/CD, and so on.

When it finishes, review what Claude wrote. The generated content is a starting point — tweak anything that's wrong or incomplete.

## Step 2: `/todo populate`

If you want to regenerate the task list (or if `/vibestack` already seeded it and you want a fresh analysis), run:

```
/todo populate
```

Claude re-scans the codebase, checks what's already been completed, and writes a new batch of prioritized tasks. The prioritization framework is:

1. Security and data integrity
2. Core reliability
3. Testing
4. CI/CD and deployment
5. Observability
6. Performance
7. User experience
8. Developer experience

Each task is specific and actionable — not "improve security" but "add rate limiting to `/api/` routes in `src/middleware/`."

## Step 3: `/todo`

Now put Claude to work:

```
/todo
```

Claude reads TODO.md and starts working through the tasks from top to bottom. For each task, it:

1. **Claims it** — marks the task `[~]` (pending) so parallel agents know it's taken
2. **Understands it** — reads relevant code and docs
3. **Executes it** — writes code, runs commands, whatever the task requires
4. **Verifies it** — runs tests or checks to make sure nothing broke
5. **Marks it done** — changes the task to `[x]`

You can also limit how many tasks to run:

```
/todo 3
```

This runs only the next 3 uncompleted tasks and stops.

While Claude works, you can do other things. The finish notification hook plays a sound when it's done.

## Step 4: `/docs`

After a work session, capture what was learned:

```
/docs
```

Claude reviews the conversation — decisions made, architectural changes, integration quirks discovered — and writes them into the `docs/` folder. It also scans existing docs for stale references, broken links, and outdated content.

This is how your project's knowledge base grows over time. Each session adds a little more context that future sessions can draw on.

## The Full Loop

That's the core vibestack workflow:

```
/vibestack     → configure the project (once)
/todo populate → seed the task list
/todo          → execute tasks
/docs          → capture learnings
```

In ongoing development, you'll mostly use `/todo` and `/docs`. Run `/todo populate` when you've cleared the list and need fresh tasks. Run `/vibestack` again if the project structure changes significantly.

## What to Expect

Your first run will take a few minutes as Claude reads through your codebase. After that, sessions are faster because the convention files provide a head start.

A few things to keep in mind:

- **Review Claude's work.** The generated content is good but not perfect. Check CLAUDE.md for accuracy, review ops.sh commands, and sanity-check the TODO priorities.
- **You control publishing.** Claude can commit and push code, but it won't publish or deploy. That's always your call.
- **It gets better over time.** The more docs and context that accumulate, the more accurate Claude's work becomes. The first session is the roughest — it improves from there.

## Next Steps

Now that you've done your first run, dig into the core concepts to understand each convention file in detail:

- [CLAUDE.md — The Project Brain](../core-concepts/claude-md.md)
- [TODO.md — Task Tracking](../core-concepts/todo-md.md)
- [ops.sh — One CLI to Rule Them All](../core-concepts/ops-sh.md)
- [docs/ — Living Documentation](../core-concepts/docs.md)
