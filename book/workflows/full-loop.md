# The Full Loop

This chapter walks through a complete vibestack session — from a fresh install to shipping working code. Follow along with a real project or use it as a mental model for how the pieces fit together.

## Starting Point

You have an existing project. Maybe it's a Node API, a Go service, a Python CLI, or a React app. It has code, maybe some tests, probably not enough docs. You want Claude to help you build it faster.

## Phase 1: Install

```bash
cd ~/projects/my-app
curl -fsSL https://raw.githubusercontent.com/vibestackmd/vibestack/main/install.sh | bash
```

Takes under a minute. You now have [`CLAUDE.md`](../core-concepts/claude-md.md), [`TODO.md`](../core-concepts/todo-md.md), [`ops.sh`](../core-concepts/ops-sh.md), [`docs/`](../core-concepts/docs.md), and `.claude/skills/` in your project. All templates — nothing is filled in yet.

## Phase 2: Configure

Launch Claude Code and run the setup skill:

```bash
claw
```

```
/vibestack
```

(See the [`/vibestack` skill chapter](../skills/vibestack.md) for details on what this command does.)

Claude spends a minute or two reading your codebase. Then it:

- Fills out `CLAUDE.md` with your real tech stack, project structure, and conventions
- Configures `ops.sh` with your actual build, test, and run commands
- Writes starter docs based on what it found
- Seeds `TODO.md` with 10-20 prioritized engineering tasks

Review the output. Fix anything that's wrong. This is the foundation every future session builds on, so it's worth getting right.

## Phase 3: Work

Start executing tasks:

```
/todo
```

Claude reads TODO.md, picks up the first open task, and gets to work. (See [`/todo`](../skills/todo.md) for the full workflow.) It reads relevant code, makes changes, runs tests, and marks the task done. Then it moves to the next one.

A typical session might look like:

```
Task 1: Add input validation to user registration endpoint
  → Reads src/handlers/users.ts
  → Adds zod schema validation
  → Writes tests for validation edge cases
  → Runs ./ops.sh test — all pass
  → Marks done ✓

Task 2: Move hardcoded secrets to environment variables
  → Greps for hardcoded strings across the codebase
  → Creates .env.example with all required variables
  → Updates code to read from process.env
  → Runs ./ops.sh test — all pass
  → Marks done ✓

Task 3: Add rate limiting to public API endpoints
  → Reads existing middleware stack
  → Adds express-rate-limit to /api/ routes
  → Configures separate limits for auth vs general endpoints
  → Writes integration test
  → Marks done ✓
```

You can watch in real-time or go do something else — the finish notification hook plays a sound when Claude stops.

## Phase 4: Capture

After the work session, capture what was learned:

```
/docs
```

Claude reviews the conversation (see [`/docs`](../skills/docs.md)) and writes up anything worth preserving:

- The rate limiting strategy and why those limits were chosen
- The validation schema patterns used across endpoints
- Any surprises or gotchas discovered during the work

These docs become context for the next session. Future Claude conversations start smarter because of what this session contributed.

## Phase 5: Review and Ship

Review the changes Claude made:

```bash
git diff
git log --oneline -10
```

If everything looks good, commit and push. You handle the publishing — Claude wrote the code, you ship it.

## The Loop Continues

Next session:

```bash
claw
/todo
```

Claude reads CLAUDE.md (knows your project), reads TODO.md (knows what's next), reads docs/ (knows what was learned), and picks up right where the last session left off.

When the task list runs dry:

```
/todo populate
```

Claude re-scans the codebase, sees what's improved since last time, and [generates the next batch of tasks](../core-concepts/todo-md.md).

## Timing

A rough sense of how long each phase takes:

| Phase | Time |
|-------|------|
| Install | < 1 minute |
| `/vibestack` configure | 2-5 minutes |
| `/todo` per task | 1-10 minutes depending on complexity |
| `/docs` capture | 1-2 minutes |
| Your review | As long as you need |

The first full loop takes the longest because everything is being set up. After that, sessions are mostly `/todo` and `/docs` — fast, focused, and productive.

## Real-World Pattern

In practice, most developers settle into this rhythm:

1. Start the day with `claw` and `/todo 3` — knock out a few tasks
2. Review the changes, maybe adjust a few things manually
3. Run `/docs` to capture learnings
4. Commit and push
5. Repeat in the afternoon or next day

The key insight is that vibestack makes AI work accumulate. Each session builds on the last because the convention files, docs, and completed task history provide growing context. The 10th session is dramatically more productive than the 1st.
