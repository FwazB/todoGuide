# Team Collaboration

When multiple developers use vibestack on the same project, the conventions scale naturally. [CLAUDE.md](../core-concepts/claude-md.md) gives everyone the same context, [TODO.md](../core-concepts/todo-md.md) prevents duplicate work, and [squad mode](../advanced/squad-mode.md) partitions ownership. This chapter covers the patterns that make team AI-assisted development work.

## Shared Context

The biggest win for teams is that every developer's Claude session starts with the same understanding of the project. When developer A fills out CLAUDE.md during setup, developer B's Claude sessions benefit immediately.

This eliminates the "Claude does it differently for everyone" problem. Without shared conventions, each developer teaches Claude their own patterns. The codebase drifts. With vibestack, conventions are committed to the repo and everyone — human and AI — follows the same rules.

## Agent Collision Prevention

TODO.md's `[~]` pending marker is designed for this. When two developers run `/todo` at the same time:

```
Developer A's Claude:
  → Reads TODO.md
  → Finds "Add input validation" is [ ] (open)
  → Marks it [~] (pending)
  → Starts working

Developer B's Claude:
  → Reads TODO.md
  → Sees "Add input validation" is [~] (taken)
  → Skips to "Add rate limiting" which is [ ]
  → Marks it [~]
  → Starts working
```

Both developers make progress on different tasks without stepping on each other.

### Practical Limits

The collision prevention is file-based, not atomic. If two agents read TODO.md at the exact same millisecond, they could theoretically grab the same task. In practice this almost never happens because:

- File reads and writes are sequential within a session
- There's always a time gap between reading the file and marking it pending
- If it does happen, the worst case is duplicate work, not data loss

For teams larger than 3-4 parallel sessions, consider splitting TODO.md into domain-specific task lists or using squad mode to assign domains.

## Squad Mode for Domain Ownership

On a team, different people own different parts of the codebase. The frontend developer shouldn't need to understand database migration conventions, and the infrastructure engineer doesn't need to know your React component patterns.

[`/squad`](../skills/squad.md) solves this by creating domain-specific rules:

```
.claude/rules/
  frontend.md     # React patterns, component conventions, styling rules
  api.md          # Endpoint patterns, middleware conventions, error handling
  data-layer.md   # Database access, migration rules, query patterns
  infra.md        # Deployment config, CI/CD, Docker conventions
```

When a developer works on frontend files, Claude automatically loads `frontend.md`. When they switch to the API layer, `api.md` loads instead. Each domain has the right context without cluttering the global CLAUDE.md.

### Assigning Domains

A natural team workflow:

1. Run `/squad` to identify domains
2. Assign each domain to a developer (or pair)
3. Domain owners refine their rule files with specific conventions
4. Everyone benefits from the domain-specific context

The rule files are committed to the repo, so domain knowledge is shared even if the domain owner is unavailable.

## Branching and Merging

vibestack convention files live in the repo and follow normal git workflows:

- **CLAUDE.md** — rarely conflicts since it's edited infrequently after setup
- **TODO.md** — merge conflicts happen when two developers complete different tasks. These are easy to resolve: keep both `[x]` markers
- **docs/** — conflicts are uncommon since docs are usually about different topics
- **ops.sh** — rarely edited after initial setup

### Recommended Git Workflow

```
main               # Production-ready code
├── feature/auth   # Developer A working on auth tasks
├── feature/api    # Developer B working on API tasks
└── feature/infra  # Developer C working on infrastructure
```

Each developer branches from main, runs `/todo` on their branch, and opens a PR when done. TODO.md changes (marking tasks done) merge cleanly in most cases.

## Communication Patterns

### Daily Standups with `/bosskey`

Each developer runs [`/bosskey`](../skills/bosskey.md) to generate their standup update from git history. No manual status writing needed:

```bash
claw
/bosskey
```

Output is ready to paste into Slack or recite in a meeting.

### Task Assignment

Instead of free-for-all `/todo`, you can assign specific tasks:

```markdown
## Backlog

- [ ] [Alice] Add OAuth2 support to the auth service
- [ ] [Bob] Optimize database queries in the reporting module
- [ ] [Carol] Set up staging environment on AWS
```

Claude respects these markers and skips tasks assigned to other people.

### Knowledge Sharing via Docs

When a developer's Claude session discovers something non-obvious — an API quirk, a performance gotcha, a subtle bug pattern — `/docs` captures it. The next developer's session reads that doc and avoids the same pitfall.

This creates a compound knowledge effect. The team gets smarter over time because insights aren't lost when a conversation ends.

## Scaling Tips

- **Start with CLAUDE.md and TODO.md.** Don't add squad mode until the project is large enough that different areas have genuinely different conventions.
- **One person owns CLAUDE.md.** Too many editors leads to drift. Designate someone to keep it accurate and concise.
- **Review AI-generated docs.** When Claude writes docs via `/docs`, have a team member review them. AI-generated docs are usually good but sometimes miss nuance.
- **Keep TODO.md under 20 items.** With a team, tasks get completed faster. Run `/todo populate` more frequently to keep the list fresh and relevant.
- **Use PRs for convention changes.** If someone wants to change CLAUDE.md or a rule file, it should go through code review like any other change. These files affect everyone's AI sessions.
