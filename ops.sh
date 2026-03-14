#!/usr/bin/env bash
# ops.sh — project CLI
#
# Single entry point for all project operations: build, run, test, deploy.
# Both humans and AI agents use this as the "how do I do anything" reference.
#
# Usage: ./ops.sh <command> [args]

set -euo pipefail

# ──────────────── Config ────────────────

PROJECT_NAME="todoGuide"

# ──────────────── Helpers ────────────────

die() { echo "Error: $*" >&2; exit 1; }

# ──────────────── Commands ────────────────

cmd="${1:-help}"
shift || true

# ─── build ──────────────────────────────────────────────

if [[ "$cmd" == "build" ]]; then

    echo "Building $PROJECT_NAME..."
    echo "GitBook builds are handled by gitbook.com on push to main."
    echo "No local build step required."

# ─── test ───────────────────────────────────────────────

elif [[ "$cmd" == "test" ]]; then

    echo "Running tests..."
    # Check for broken internal links and validate markdown structure
    echo "Checking markdown files..."
    find book -name "*.md" -print0 2>/dev/null | xargs -0 -I{} sh -c 'echo "  {}"' || echo "No book/ directory yet"
    echo "Checking SUMMARY.md references..."
    if [[ -f book/SUMMARY.md ]]; then
        while IFS= read -r line; do
            if [[ "$line" =~ \(([^)]+\.md)\) ]]; then
                ref="${BASH_REMATCH[1]}"
                if [[ ! -f "book/$ref" ]]; then
                    echo "  BROKEN LINK: $ref"
                fi
            fi
        done < book/SUMMARY.md
        echo "Link check complete."
    else
        echo "  No book/SUMMARY.md yet"
    fi

# ─── run ────────────────────────────────────────────────

elif [[ "$cmd" == "run" ]]; then

    PORT="${1:-4000}"
    echo "Serving $PROJECT_NAME locally on http://localhost:$PORT ..."
    cd book && python3 -m http.server "$PORT"

# ─── deploy ─────────────────────────────────────────────

elif [[ "$cmd" == "deploy" ]]; then

    TARGET="${1:-}"
    [[ -n "$TARGET" ]] || die "Usage: ./ops.sh deploy <target>"

    die "Deploy/publish is user-only. The user must trigger GitBook publishing manually."

# ─── logs ───────────────────────────────────────────────

elif [[ "$cmd" == "logs" ]]; then

    TARGET="${1:-}"
    [[ -n "$TARGET" ]] || die "Usage: ./ops.sh logs <target>"

    echo "Tailing logs for $TARGET..."
    echo "GitBook doesn't expose build logs via CLI."
    echo "Check https://app.gitbook.com for build status."

# ─── status ─────────────────────────────────────────────

elif [[ "$cmd" == "status" ]]; then

    echo "$PROJECT_NAME status..."
    echo ""
    echo "Chapters:"
    if [[ -d book ]]; then
        find book -name "*.md" | wc -l | xargs echo "  Markdown files:"
        wc -w book/**/*.md 2>/dev/null | tail -1 | xargs echo "  Total words:" || echo "  Total words: 0"
    else
        echo "  No book/ directory yet"
    fi
    echo ""
    echo "Git:"
    git log --oneline -5 2>/dev/null || echo "  Not a git repo yet"

# ─── docs ───────────────────────────────────────────────

elif [[ "$cmd" == "docs" ]]; then

    PORT="${1:-3000}"
    echo "Serving internal docs on http://localhost:$PORT ..."
    cd docs && python3 -m http.server "$PORT"

# ─── help ───────────────────────────────────────────────

elif [[ "$cmd" == "help" ]]; then

    cat << 'EOF'
Usage: ./ops.sh COMMAND [args]

Build & run:
  build                  Show build info (GitBook builds on push)
  test                   Validate markdown links and structure
  run [port]             Serve book locally (default: 4000)

Deploy & manage:
  deploy <target>        Deploy info (gitbook auto-deploys from main)
  logs <target>          Build log info
  status                 Show chapter count and recent commits

Utilities:
  docs [port]            Serve internal docs locally (default: 3000)

Examples:
  ./ops.sh run
  ./ops.sh test
  ./ops.sh status
  ./ops.sh deploy prod

EOF

else
    die "Unknown command: $cmd (try: ./ops.sh help)"
fi
