# ops.sh — One CLI to Rule Them All

Every project has a collection of commands: how to build, how to test, how to run, how to deploy. In most projects these are scattered — some in `package.json` scripts, some in a `Makefile`, some in CI config, some in a README that's six months out of date.

`ops.sh` puts them all in one place. It's a single Bash script that both you and Claude use as the "how do I do anything?" reference.

## Why a Single Entry Point

When Claude needs to run tests, it doesn't have to figure out whether your project uses `npm test`, `pytest`, `cargo test`, or `go test ./...`. It runs `./ops.sh test`. Every time, every project.

This consistency matters because:

- **Claude doesn't guess.** It knows exactly which command to run for every operation.
- **You don't explain.** No need to tell Claude "run the tests with this flag and that config." It's in the script.
- **Onboarding is instant.** A new developer (human or AI) runs `./ops.sh help` and sees everything the project can do.

## The Standard Commands

Every `ops.sh` starts with these commands. `/vibestack` fills them in based on your project's actual tooling.

### build

Compiles, transpiles, or bundles the project.

```bash
if [[ "$cmd" == "build" ]]; then
    echo "Building $PROJECT_NAME..."
    npm run build
fi
```

### test

Runs the test suite.

```bash
elif [[ "$cmd" == "test" ]]; then
    echo "Running tests..."
    npm test
fi
```

### run

Starts the project locally for development.

```bash
elif [[ "$cmd" == "run" ]]; then
    echo "Running $PROJECT_NAME locally..."
    npm run dev
fi
```

### deploy

Deploys to a target environment.

```bash
elif [[ "$cmd" == "deploy" ]]; then
    TARGET="${1:-}"
    [[ -n "$TARGET" ]] || die "Usage: ./ops.sh deploy <target>"

    echo "Deploying $PROJECT_NAME to $TARGET..."
    vercel --prod
fi
```

### logs

Tails logs for a target environment.

### status

Shows project health — typically hits a health endpoint or checks service status.

### docs

Serves documentation locally.

### help

Prints available commands and usage examples.

## Adding Custom Commands

Your project probably needs more than the standard commands. Add them by following the existing pattern — an `elif` block and a help entry.

Say you want to add a `lint` command:

```bash
# ─── lint ───────────────────────────────────────────────

elif [[ "$cmd" == "lint" ]]; then

    echo "Linting..."
    npx eslint src/ --fix
```

Then add it to the help text:

```bash
cat << 'EOF'
Usage: ./ops.sh COMMAND [args]

Build & run:
  build                  Build the project
  test                   Run tests
  run                    Run locally
  lint                   Run linter with auto-fix
...
EOF
```

Common additions:

| Command | Example use |
|---------|-------------|
| `lint` | `npx eslint src/ --fix` |
| `typecheck` | `npx tsc --noEmit` |
| `migrate` | `npx prisma migrate dev` |
| `seed` | `npx prisma db seed` |
| `format` | `npx prettier --write .` |
| `clean` | `rm -rf dist/ node_modules/` |

## Structure of the Script

```bash
#!/usr/bin/env bash
set -euo pipefail          # Fail fast on errors

# Config
PROJECT_NAME="myproject"   # Used in log messages

# Helpers
die() { echo "Error: $*" >&2; exit 1; }

# Command dispatch
cmd="${1:-help}"
shift || true

if [[ "$cmd" == "build" ]]; then
    # ...
elif [[ "$cmd" == "test" ]]; then
    # ...
elif [[ "$cmd" == "help" ]]; then
    # ...
else
    die "Unknown command: $cmd (try: ./ops.sh help)"
fi
```

Key details:

- `set -euo pipefail` makes the script fail on any error instead of silently continuing.
- The `die` helper prints an error message and exits with code 1.
- Unknown commands get caught by the final `else` block.
- `shift || true` prevents an error when no arguments are passed.

## Tips

- **Keep commands simple.** Each command should do one thing. If a command gets complex, extract the logic into a separate script and call it from `ops.sh`.
- **Use `$@` for passthrough args.** If a command needs extra arguments, pass them through: `npm test -- "$@"`.
- **Don't duplicate CI.** If your CI pipeline already runs lint + test + build, `ops.sh` should use the same commands. One source of truth.
- **Update help when you add commands.** The help text is how Claude (and your teammates) discover what's available.
