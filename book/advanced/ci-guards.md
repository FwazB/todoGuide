# CI Guards

vibestack includes GitHub Actions workflow templates for automated validation. These "CI guards" run on every push and pull request, catching issues before they reach production. They replace the need for interactive approval gates — instead of asking "should I run the linter?", the CI pipeline just runs it.

## Philosophy

vibestack favors **CI over gates**. Instead of Claude asking for permission to run checks, the CI pipeline runs them automatically on every push. If something fails, you see it in the PR checks. This keeps the agent moving forward during work sessions while still catching problems before merge.

## Available Templates

vibestack ships CI guard templates for four language ecosystems. Each template covers three areas: lint, test coverage, and security scanning.

### Node.js

```yaml
name: CI Guards
on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npx eslint .
      - run: npx tsc --noEmit

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm test -- --coverage
      - uses: codecov/codecov-action@v4

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm audit --audit-level=high
```

### Python

```yaml
jobs:
  lint:
    steps:
      - run: pip install ruff pyright
      - run: ruff check .
      - run: pyright

  test:
    steps:
      - run: pip install pytest pytest-cov
      - run: pytest --cov=src --cov-report=xml

  security:
    steps:
      - run: pip install safety
      - run: safety check
```

### Rust

```yaml
jobs:
  lint:
    steps:
      - run: cargo fmt --check
      - run: cargo clippy -- -D warnings

  test:
    steps:
      - run: cargo test
      - run: cargo tarpaulin --out xml

  security:
    steps:
      - run: cargo install cargo-audit
      - run: cargo audit
```

### Go

```yaml
jobs:
  lint:
    steps:
      - run: go vet ./...
      - uses: golangci/golangci-lint-action@v4

  test:
    steps:
      - run: go test -race -coverprofile=coverage.out ./...

  security:
    steps:
      - run: go install golang.org/x/vuln/cmd/govulncheck@latest
      - run: govulncheck ./...
```

## Setting Up CI Guards

### Step 1: Choose your template

Pick the template matching your language. If your project uses multiple languages, combine them into one workflow.

### Step 2: Create the workflow file

```bash
mkdir -p .github/workflows
```

Create `.github/workflows/ci.yml` with the appropriate template content.

### Step 3: Customize

Adjust the template for your project:

- **Node version** — match your `.nvmrc` or `package.json` engines field
- **Test command** — use whatever `./ops.sh test` runs
- **Coverage thresholds** — add minimum coverage requirements if you have them
- **Security exceptions** — some audit findings are acceptable (unmaintained but not vulnerable packages)

### Step 4: Push and verify

Push the workflow file and check that it runs on your next commit. Fix any failures before continuing with other work.

## What CI Guards Catch

| Check | What it catches |
|-------|----------------|
| Lint | Style violations, unused imports, naming issues |
| Type check | Type errors, missing properties, wrong argument types |
| Tests | Broken functionality, regression bugs |
| Coverage | Untested code paths |
| Security audit | Known vulnerabilities in dependencies |

## Tips

- **Don't skip CI for "small" changes.** A one-line change can break types across the project.
- **Keep CI fast.** If your pipeline takes more than 5 minutes, developers (and Claude) will stop waiting for it. Cache dependencies, parallelize jobs, skip unnecessary steps.
- **Fix failures immediately.** A red CI that everyone ignores is worse than no CI. If a check fails, either fix the issue or remove the check.
- **Match CI with local checks.** The commands in your CI pipeline should be the same ones in `ops.sh`. If `./ops.sh test` passes locally, CI should pass too.
