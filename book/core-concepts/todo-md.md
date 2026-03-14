# TODO.md — Task Tracking

`TODO.md` is a lightweight task tracker designed for human/AI collaboration. It's a plain Markdown file with checkboxes — simple enough that both you and Claude can read and edit it without any tooling.

## The Format

```markdown
# TODO

AGENTS: When prompted, complete tasks from the list below. Before starting work,
mark the item as pending `[~]` so parallel agents don't collide. After completion,
mark it `[x]`. Start at the top unless the user specifies otherwise.

## Backlog

- [ ] Add rate limiting to public API endpoints in `src/middleware/`
- [ ] Write integration tests for the payment flow in `src/services/payment.ts`
- [ ] Move hardcoded secrets to environment variables
```

The header at the top contains instructions for AI agents. Claude reads these before starting work. The backlog is a flat, ordered list — highest priority at the top.

## The Three States

Each task has one of three states:

| Marker | State | Meaning |
|--------|-------|---------|
| `[ ]` | Open | Available for work |
| `[~]` | Pending | Someone (human or AI) is working on it |
| `[x]` | Done | Completed |

The pending state is what makes TODO.md work with AI agents. When Claude picks up a task, it immediately marks it `[~]` before doing any work. This signals to other agents (or to you) that the task is taken.

## Agent Collision Prevention

If you run multiple Claude sessions in parallel — say, one working on frontend tasks and another on backend — the pending marker prevents them from grabbing the same task.

```markdown
- [~] Add input validation to user registration endpoint  ← Agent 1 is on this
- [ ] Add rate limiting to public API endpoints           ← Available
- [ ] Write unit tests for the auth service               ← Available
```

Agent 2 sees the `[~]` and skips to the next `[ ]` item. No coordination needed, no race conditions, no duplicated work.

This isn't bulletproof — two agents could theoretically grab the same task in the same instant — but in practice it works well because agents read and write the file sequentially.

## How [`/todo`](../skills/todo.md) Works

When you run `/todo`, Claude:

1. Reads `TODO.md`
2. Finds all `[ ]` items (skips `[~]` and `[x]`)
3. Takes the first open item, marks it `[~]`
4. Does the work — reads code, writes code, runs tests
5. Marks the item `[x]`
6. Moves to the next open item

You can limit how many tasks to run in one session:

```
/todo 3
```

This runs up to 3 tasks and stops.

If a task is blocked — missing credentials, unclear requirements, dependency on another task — Claude marks it back to `[ ]`, adds a note explaining the blocker, and moves on.

## How `/todo populate` Works

When you run [`/todo populate`](../skills/todo.md), Claude:

1. Reads TODO.md and notes all completed tasks (so it doesn't re-add them)
2. Scans the entire codebase — config files, tests, error handling, security, CI/CD, docs
3. Identifies the most impactful engineering work that hasn't been done yet
4. Writes 10-20 new tasks, ranked by priority
5. Clears completed tasks from the list (they're done, no need to keep them)
6. Preserves any open or pending tasks that are still relevant

### The Prioritization Framework

Tasks are ranked by this priority order:

1. **Security and data integrity** — Auth, input validation, secrets management. Things that could get you hacked or lose user data.
2. **Core reliability** — Error handling, migrations, transaction safety. The app shouldn't crash or corrupt data.
3. **Testing** — Unit tests, integration tests, E2E tests. Enough coverage to deploy with confidence.
4. **CI/CD and deployment** — Automated pipelines, staging environments. Ship fast without breaking things.
5. **Observability** — Logging, error tracking, monitoring. Know when things break before users tell you.
6. **Performance** — Indexing, caching, query optimization. Handle real traffic.
7. **User experience** — Loading states, error messages, edge cases. Polish that builds trust.
8. **Developer experience** — Linting, type safety, dev setup. Makes the team faster.

## Writing Good Tasks

Whether you write tasks yourself or let `/todo populate` generate them, good tasks share these qualities:

- **Specific.** Not "improve security" but "add rate limiting to `/api/` routes in `src/middleware/`."
- **Actionable.** Claude should be able to start working immediately without asking clarifying questions.
- **Scoped.** Each task should be completable in a single session. If it's too big, split it.
- **Referenced.** Mention actual files, functions, or endpoints so Claude knows where to look.

```markdown
# Good
- [ ] Add input validation to `POST /api/users` in `src/handlers/users.ts` — validate email format, password length, and required fields

# Too vague
- [ ] Improve the user registration flow
```

## Tips

- **Start from the top.** Tasks are ordered by priority. Work them in order unless you have a reason not to.
- **Run `/todo populate` when the list is empty.** It analyzes the current state of the code and generates the next batch.
- **Add your own tasks.** TODO.md isn't only for AI-generated tasks. Add items manually whenever you want — just put them at the right priority level.
- **Don't over-fill it.** 10-20 tasks is the sweet spot. More than that and the list becomes noise. Less than that and you'll need to repopulate too often.
