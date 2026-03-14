# /bosskey -- Standup Generator

`/bosskey` reads your recent git history and writes a standup script you can recite word-for-word. It looks at actual diffs, not just commit messages, so even a commit called "fix stuff" turns into something that sounds deliberate and professional.

This is a fun, practical skill that saves you time on status updates. No more staring at a blank Slack message trying to remember what you did yesterday.

## What It Does

When you type `/bosskey`, Claude:

1. Identifies your git user
2. Gathers your recent commits
3. Reads the actual diffs to understand what changed
4. Translates implementation details into natural-sounding status bullets
5. Outputs a standup script and a shorter hallway version

The whole thing takes about 30 seconds.

## How It Works

### Step 1: Identify the User

Claude runs `git config user.name` to get your identity and uses it as the author filter for all log queries.

### Step 2: Gather Recent Commits

Claude pulls two sets of commits and merges them, taking whichever set is larger:

```bash
# Last 3 days of commits
git log --author="Jane Developer" --since="3 days ago" --pretty=format:"%H %s" --no-merges

# Last 10 commits regardless of date
git log --author="Jane Developer" --pretty=format:"%H %s" --no-merges -10
```

The "whichever is larger" logic handles both scenarios: a busy week where you committed 15 times in 3 days, and a slow stretch where your last 10 commits span two weeks.

### Step 3: Read the Actual Diffs

For each commit, Claude reads the diff:

```bash
git show abc123f --stat
git show abc123f
```

This is the key step. Commit messages lie -- or at least they're vague. "Updated auth" could mean you fixed a critical security bug or renamed a variable. Claude reads the code to understand what actually happened, so the standup script reflects real work.

### Step 4: Synthesize the Update

Claude groups related commits, identifies themes, and writes 3 to 6 bullets that cover your work.

## The Tone

The output sounds like a real person talking, not a project manager's slide deck. Think "catching up a coworker in the hallway," not "presenting to the board."

The tone rules:

- **Casual confidence.** You sound like someone who's been getting things done and has it under control.
- **Vague enough that nobody asks follow-up questions.** "Hardened some edge cases in the data pipeline" invites a nod. "Fixed the null pointer exception in `processOrder` when `shippingAddress.zip` is undefined" invites fifteen minutes of questions.
- **Specific enough to sound real.** Pure vagueness sounds evasive. You want enough detail that people know you're doing actual work.
- **Contractions.** "I've been" not "I have been." "It's" not "it is." Write how people talk.
- **No corporate buzzwords.** No "synergy," no "leverage," no "align," no "circle back." Just normal words.
- **Short, plain sentences.** No em dashes. Minimal punctuation. Say it simply.

## The Translation Guide

Here is how implementation details translate into standup language:

| What You Actually Did | What You Say |
|--|--|
| Fixed a null pointer exception | "Hardened some edge cases in the data pipeline" |
| Added a CSS margin | "Polished the UX on a key workflow" |
| Refactored a function | "Cleaned up some tech debt in a core module" |
| Updated dependencies | "Took care of some security and stability stuff" |
| Fixed a typo in the README | "Tidied up the dev docs" |
| Added error handling | "Made a few things more resilient" |
| Wrote tests | "Added coverage on some critical paths" |
| Deleted dead code | "Trimmed the codebase, removed some stuff we weren't using" |
| Debugged for 4 hours, changed one line | "Tracked down a subtle bug and got it fixed" |
| Renamed variables | "Improved readability in a few spots" |

The pattern: translate the implementation detail into its business impact, keep it casual, and make everything sound intentional.

## Output Format

### The Standup Script

The main output is a script you can read verbatim in a standup, paste into Slack, or send in an email:

```
Here's where I'm at:

- Hardened some edge cases in the payment flow
- Added coverage on a few critical auth paths
- Cleaned up some tech debt in the notification service
- Polished the UX on the onboarding screens

Next up I'm tightening up the error handling on the webhook endpoints.
```

Three to six bullets, plus a one-liner for "what's next." The "what's next" line is inferred from open work -- uncommitted changes, recent branch context, or the next logical step from what you just finished.

### The Hallway Version

For when someone catches you off guard -- in an elevator, walking to lunch, on a random Zoom call. One sentence that covers everything:

```
"Been heads down on the payment flow and auth hardening, making good
progress. Should have more to share soon."
```

This is your escape hatch. It sounds engaged without committing to specifics. Memorize the pattern: "Been heads down on [topic], making good progress."

## Tips

- **Run it at the start of your day**, before standup. The script is right there when you need it.
- **Edit the output if needed.** Claude generates a solid draft, but you know your team. If a bullet sounds too vague or too specific for your audience, tweak it.
- **It works across branches.** If you were switching between feature branches all week, Claude still sees all your commits and synthesizes them into a coherent story.
- **The hallway version is surprisingly useful.** Keep it in your back pocket for impromptu conversations with stakeholders who don't need the full update.
