# /docs — Doc Maintenance

`/docs` captures what you learned during a work session and writes it to the right place in `docs/`. It also cleans up stale content, fixes drifted references, and makes sure your documentation matches the actual codebase.

Run it after any session where you made architectural changes, discovered integration quirks, or figured out something that would save future-you (or future-Claude) time.

## What It Does

When you type `/docs`, Claude reviews the current conversation and your docs folder, then does five things in order:

1. Gathers context from the conversation
2. Captures new information into docs
3. Cleans up stale content
4. Checks CLAUDE.md for accuracy
5. Runs a clarity pass on everything it wrote

The result is a docs folder that reflects reality, not last month's reality.

## Step 1: Gather Context

Claude reads back through the conversation looking for anything worth preserving:

- Architectural decisions ("we went with Redis over Memcached because...")
- Integration quirks ("the Stripe webhook sends `invoice.paid` before `checkout.session.completed`")
- Removed features and the reasoning behind removal
- Non-obvious behavior that someone will trip over again
- New patterns or conventions the team adopted mid-session

It also reads `CLAUDE.md` and lists everything in `docs/` so it knows what already exists before writing anything new.

## Step 2: Capture New Information

For each piece of new information, Claude finds the right home in your existing docs. It prefers adding to an existing file over creating a new one.

If you spent time debugging a Supabase edge function timeout issue and discovered that the default timeout is 2 seconds (not 30), Claude looks for an existing doc like `docs/infrastructure.md` or `docs/supabase.md` and adds a section there.

```markdown
## Edge Function Timeouts

Supabase edge functions have a 2-second default timeout, not 30 seconds as
the dashboard implies. For longer operations, set the timeout explicitly in
`supabase/config.toml`:

    [functions.my-function]
    timeout = 30
```

New docs are created only when the topic is substantial enough to stand on its own and no existing doc is a reasonable fit.

Every entry includes the "why" — not just what was decided, but the reasoning behind it. This way, the next person who reads the doc understands whether the decision still applies or whether circumstances have changed.

## Step 3: Clean Up

This is the step that keeps docs from rotting. Claude scans every file in `docs/` looking for:

- **Stale references** — features, config fields, files, or functions that no longer exist in the codebase
- **Incorrect counts or names** — test counts, enum variants, file paths, or function signatures that have drifted
- **Redundancy** — the same information duplicated across multiple docs
- **Dead links** — references to files or sections that were removed
- **Outdated examples** — command snippets or code samples that reference old flag names or deprecated workflows

The key rule: Claude verifies against the actual codebase before removing anything. It runs grep on the source to confirm that a referenced function is truly gone before deleting its documentation. This prevents overzealous cleanup from removing docs about things that still exist but live in unexpected places.

```bash
# Claude runs checks like this internally before removing a reference:
grep -r "processWebhook" src/
# No results? Safe to remove the docs about processWebhook.
```

When a section becomes empty after cleanup, the section header gets removed too. No orphaned headers, no empty bullet lists, no dangling fragments.

## Step 4: Check CLAUDE.md

`CLAUDE.md` gets the same treatment, but with higher stakes. This file loads into every Claude conversation, so stale content here causes repeated mistakes across every session.

Claude verifies:

- **File paths** listed in the project structure actually exist
- **Function names** and module descriptions match the current code
- **Command examples** still work (e.g., `./ops.sh deploy staging` still takes that argument)
- **References to deleted features** are removed
- **Conciseness** is maintained — if a section has grown too long, detailed content moves to `docs/` with a link

```markdown
## Architecture

# Before cleanup (drifted):
HTTP requests hit Express handlers in `src/routes/`, which call service
functions in `src/services/`. Services use Prisma for database access.

# After cleanup (src/routes/ was renamed to src/handlers/ two weeks ago):
HTTP requests hit Express handlers in `src/handlers/`, which call service
functions in `src/services/`. Services use Prisma for database access.
```

## Step 5: Feynman Clarity Pass

The final step applies a readability pass to everything Claude wrote or updated. The goal is to make docs clear to someone encountering the topic for the first time, without dumbing down the technical content.

The rules:

- **Plain language first.** The first sentence of each section should make sense to a non-technical reader. State what the thing does and why it matters before diving into implementation.
- **Introduce jargon on first use.** The first time a technical term appears, explain it briefly in parentheses or a short clause.
- **Layer the complexity.** Start with the wide shot, then zoom in. Overview first, details second.
- **Use analogy where it helps.** Compare non-obvious concepts to everyday things, but don't force analogies where the text is already clear.
- **Short sentences, short paragraphs.** If a sentence has more than one comma, split it. If a paragraph runs past four or five lines, break it up.
- **Active voice.** "The webhook is processed by the handler" becomes "The handler processes the webhook." Name the actor.
- **Keep all technical depth.** Don't remove config details, formulas, or implementation notes. Just make sure each one is preceded by a plain-English explanation.

If a section is already clear, it stays untouched. This pass improves what needs it, not rewrites everything.

## When to Run It

Run `/docs` when:

- You just finished a work session where you learned something non-obvious
- You made architectural changes (renamed directories, swapped a dependency, changed a deployment target)
- You removed a feature or deprecated a workflow
- You've been working for a while and suspect the docs have drifted from reality

You don't need to run it after every session. If all you did was fix a typo or add a CSS rule, there's nothing worth documenting. Use judgment — if you learned something that would save someone 30 minutes of debugging, that's worth capturing.

## What It Produces

At the end of the run, Claude gives you a summary of everything it did:

- What new information was captured and where it was placed
- What stale content was removed or corrected
- Any docs that were consolidated or restructured
- Any sections where clarity was improved

This summary is your changelog for the docs update. Skim it to make sure nothing important was removed by mistake.
