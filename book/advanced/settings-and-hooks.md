# Settings & Hooks

Out of the box, vibestack pre-approves tool access so Claude doesn't ask permission every 30 seconds, and plays a sound when it finishes so you can walk away. All of this is controlled through two files: `.claude/settings.json` for permissions and environment, and shell scripts in `.claude/hooks/` for event-driven automation. This chapter covers both.

## settings.json

The settings file lives at `.claude/settings.json` and is committed to the repo. It controls permissions, environment variables, and the status line.

### Default Configuration

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/statusline.sh\""
  },
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)",
      "Glob(*)",
      "Grep(*)",
      "WebFetch(*)",
      "WebSearch(*)"
    ]
  },
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/notify-done.sh\""
          }
        ]
      }
    ]
  }
}
```

### Permissions

The `permissions.allow` array pre-approves tool access. Without these, Claude asks for permission every time it wants to read a file, run a command, or make an edit.

```json
"permissions": {
  "allow": [
    "Bash(*)",       // Run any shell command
    "Read(*)",       // Read any file
    "Write(*)",      // Write any file
    "Edit(*)",       // Edit any file
    "Glob(*)",       // Search for files by pattern
    "Grep(*)",       // Search file contents
    "WebFetch(*)",   // Fetch web pages
    "WebSearch(*)"   // Search the web
  ]
}
```

This is the "bypass permissions" [design opinion](../getting-started/what-is-vibestack.md#four-design-opinions). Claude can work autonomously without stopping to ask "can I read this file?" at every step.

**Security note:** These permissions are broad. They're appropriate for local development where you trust the AI agent. For shared environments or production access, scope them down.

You can restrict permissions to specific patterns:

```json
"permissions": {
  "allow": [
    "Bash(npm *, cargo *, go *)",
    "Read(src/**)",
    "Write(src/**)",
    "Edit(src/**)"
  ]
}
```

### Environment Variables

The `env` section sets environment variables for Claude Code sessions.

```json
"env": {
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
}
```

`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` enables [squad mode](squad-mode.md) — letting Claude spawn specialist subagents defined in `.claude/agents/`.

Add project-specific variables here if Claude needs them during sessions (non-secret values only — use `.env` files for secrets).

### Status Line

The `statusLine` setting runs a command whose output appears in Claude Code's status bar.

```json
"statusLine": {
  "type": "command",
  "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/statusline.sh\""
}
```

The default `statusline.sh` shows useful project state — current git branch, number of pending TODO items, last test result, etc.

## Hooks

Hooks are shell commands that run in response to Claude Code events. They're defined in `settings.json` and the scripts live in `.claude/hooks/`.

### Stop Hook (Finish Notification)

Runs when Claude finishes a task or stops working:

```json
"hooks": {
  "Stop": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/notify-done.sh\""
        }
      ]
    }
  ]
}
```

The default `notify-done.sh` plays a system sound to alert you that Claude is done. This is the "finish notification" design opinion — you can context-switch to other work and get notified when Claude needs your attention.

### Customizing notify-done.sh

On macOS, the default script uses `afplay` or `osascript` to play a sound. You can customize it:

```bash
#!/usr/bin/env bash
# Play a specific sound
afplay /System/Library/Sounds/Glass.aiff

# Or send a macOS notification
osascript -e 'display notification "Claude is done" with title "Claude Code"'

# Or send a Slack message
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Claude finished a task"}' \
  "$SLACK_WEBHOOK_URL"
```

### Customizing statusline.sh

The status line script can show anything useful:

```bash
#!/usr/bin/env bash

# Git branch
BRANCH=$(git branch --show-current 2>/dev/null || echo "no-git")

# Pending TODO count
PENDING=$(grep -c '^\- \[ \]' TODO.md 2>/dev/null || echo 0)

# Output
echo "[$BRANCH] $PENDING tasks remaining"
```

### Adding Custom Hooks

You can add hooks for other events. The `matcher` field filters which tool invocations trigger the hook:

```json
"hooks": {
  "Bash": [
    {
      "matcher": "npm test",
      "hooks": [
        {
          "type": "command",
          "command": "echo 'Tests were run' >> /tmp/claude-test-log.txt"
        }
      ]
    }
  ]
}
```

## Tips

- **Commit settings.json.** It's project configuration that should be shared across the team. Everyone gets the same Claude Code behavior.
- **Don't put secrets in settings.json.** Use `.env` files for API keys and credentials. Settings.json is committed to git.
- **Test hooks manually.** Run `bash .claude/hooks/notify-done.sh` directly to make sure it works before relying on it during a session.
- **Keep the status line fast.** The command runs frequently. If it takes more than a second, it'll slow down the Claude Code interface. Avoid network calls or expensive git operations.
