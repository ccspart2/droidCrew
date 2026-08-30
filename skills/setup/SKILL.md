---
name: setup
description: Set up droidCrew in the current Android repo — verify the Claude Design MCP, discover and route installed skills to agents, detect the project profile, choose models, backlog source and designer mode, and scaffold docs/droidcrew/. Re-run with --skills to refresh skill routing only.
disable-model-invocation: true
argument-hint: "[--skills] [--mcp]"
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, AskUserQuestion
---

# /droidcrew:setup

You are running droidCrew's setup for the repository in the current working directory. Templates live in `${CLAUDE_PLUGIN_ROOT}/templates/`. State goes to `docs/droidcrew/`. Work through the steps in order; skip to the named step when an argument is given (`--skills` → step 2 only, `--mcp` → step 1 only). Ask questions with AskUserQuestion; never guess a choice the user should make.

If `docs/droidcrew/config.json` already exists, read it and treat this as a re-run: show current values and let the user keep or change each.

## Step 1 — Claude Design MCP

Run `claude mcp list` and classify the `claude-design` server:

- **connected** — a line with `claude-design` and ✔.
- **unauthorized** — present but failing with 401/403 → tell the user to run `/login` (their token is missing the scope this server needs), then re-run `/droidcrew:setup --mcp`.
- **missing** — not listed → offer to add it: `claude mcp add --transport http claude-design https://api.anthropic.com/v1/design/mcp` (ask before running; it changes user config).

Record the result as `mcp.claudeDesign`. Explain that the Designer works in spec-only mode until it is `connected`.

## Step 2 — Skills discovery and routing

Scan these sources for `SKILL.md` files and read each one's frontmatter `name` and `description` (and the first 20 lines if the description is thin):

1. `.claude/skills/*/SKILL.md` (project)
2. `~/.claude/skills/*/SKILL.md` (user)
3. Installed plugins: run `claude plugin list` and scan each plugin's `skills/*/SKILL.md`; skip droidcrew's own skills.

Classify each by keywords in name/description — propose, do not decide:

| Signals | Route to |
|---|---|
| compose, kotlin, coroutines, flow, gradle, navigation, testing, junit, espresso, debugging, android, data layer, source search | Coder, QA |
| hilt, koin, dagger, room, datastore, retrofit, ktor, paging, coil, okhttp, serialization, rxjava, kmp, multiplatform | Coder, QA — almost always **on demand** |
| material, m3, design, ux, ui, wireframe, figma, accessibility, typography, colour, motion | Designer (and QA when it is a token or accessibility skill) |
| architecture, modularization, planning, clean, mvvm, mvi, boundaries | Orchestrator, QA |
| edge-to-edge, adaptive, window size | Designer, Coder — **on demand** |
| anything else | ask, and default to Not routed |

**Then assign a tier to each — this matters more than the agent.**

- **Always** (read in full every session): only skills that apply to **every kind of item this
  project will produce**, not just the most common kind. **Cap at three per agent** and say why each
  earned its slot.

  Test a candidate this way: *name an item where reading it would not change a line.* If you can
  name one, it belongs On demand. A UI-toolkit skill fails this test in any project that also has
  pure-logic items — an engine, a parser, build config — because the Coder pays a full read on every
  one of them. Route it with a trigger like "when the diff contains Composables or touches UI"
  instead. A general Android or Kotlin conventions skill usually passes; a library skill never does.
- **On demand**: everything else. Write a one-line **trigger** — "when the work touches Room",
  "when a layout must respond to window size". The agent reads triggers, and reads the skill only
  when one fires.
- **Not routed**: discovered but irrelevant here. Record why, so a re-run does not re-propose it.

If more than about six skills are discovered, say plainly that routing them all to Always would
crowd out the project's own documents, and propose a small Always set with the rest on demand.

Be honest about what the tiers do and do not buy: an installed skill's *description* is loaded every
session no matter how it is routed, so tiering does not reduce the cost of installing a pack. It
controls full reads only. Say so once, with the measured number if you can get it, so the user is
not misled into thinking routing made an oversized pack free.

Prefer a skill's **own stated trigger** over your keyword guess when it has one — a skill that says
it applies only to multi-module projects is Not routed in a single-module repo, whatever its name
suggests.

Show the proposal as the three tables and let the user move any row between tiers or agents. Write
the confirmed result to `docs/droidcrew/skills.md` using the template. If nothing was discovered,
write the template as-is and name the kinds of skill worth installing (Material 3, Compose/Android
conventions, design craft, Android testing) — do not install anything.

## Step 3 — Project profile

Detect from the repo and write `docs/droidcrew/profile.md`:

- Gradle: `settings.gradle(.kts)` modules; `app/build.gradle(.kts)` namespace, minSdk/targetSdk/compileSdk, Compose BOM, Hilt, navigation, Room/DataStore/Retrofit/Ktor; `gradle/libs.versions.toml` versions.
- Architecture signals: ViewModels, StateFlow vs LiveData, Channel/SharedFlow, fakes vs mocks in tests, the theme package (where `Color.kt`/`Type.kt`/`Spacing.kt` live), `CLAUDE.md` conventions.
- Test baseline: if the user agrees, run the test command and count from the XML; otherwise record "unverified".

If there is no Android project (greenfield), run a short questionnaire instead: app name and package, minSdk, DI (Hilt default), navigation, persistence, and the product's domain invariants for `PRODUCT.md` Non-negotiables. Do not generate the project — that is the Coder's job from a plan.

## Step 4 — Choices

Ask, with the defaults pre-selected:

1. **Models** per agent — defaults Orchestrator opus, Designer opus, Coder sonnet, QA opus. Explain: reviewing on the same tier as the Coder defeats the QA gate.
2. **Backlog source** — `file` (`docs/droidcrew/BACKLOG.md` with an Inbox) or `github` (issues via `gh`/GitHub MCP). Offer `github` only if `gh auth status` succeeds or a GitHub MCP is listed. Ask for the item id prefix (e.g. `FB`).
3. **Designer mode** — `operate` (Designer drives Claude Design) or `guide` (user drives, Designer teaches step by step).
4. **Write guard** — keep enabled (blocks source edits outside the code stage) or disable.

## Step 5 — Scaffold

Copy **only these files** from `${CLAUDE_PLUGIN_ROOT}/templates/` into `docs/droidcrew/`, without overwriting anything that already exists (ask per file on a re-run):

`config.json` (filled from steps 1–4) · `STATUS.md` · `skills.md` · `profile.md` · `PRODUCT.md` (seed the Non-negotiables with the defaults plus any domain invariants gathered) · `DESIGN.md` · `BACKLOG.md` (only for `file` source).

Then create `design/`, `plans/` and `qa/` as **empty** directories, each with a `.gitkeep`.

**Do not copy `templates/design/spec.md`, `templates/plans/plan.md`, `templates/qa/report.md` or `templates/qa/fidelity.md` into the repo.** Those are per-item shapes the Designer, Orchestrator and QA fill in at `design/<item>/spec.md`, `plans/<item>.md`, `qa/<item>.md` and `qa/<item>-fidelity.md`. A bare `spec.md` or `report.md` sitting in those directories is a file no agent owns, and it invites an agent to overwrite it instead of creating the real per-item file.

Create `docs/screenshots/.gitkeep`.

Append to `.gitignore` if not present:

```
docs/droidcrew/DESIGN_BRIEF.md
docs/droidcrew/NEXT_PROMPT.md
docs/droidcrew/RESULTS.md
docs/droidcrew/.stage
```

Write `docs/droidcrew/.stage` containing `idle`.

## Step 6 — Report

Summarize in chat: MCP state, how many skills were routed to whom, the detected stack and test baseline, the choices made, and the files created. Then tell the user the next step: bring a backlog item to `/droidcrew:plan`, or start with `/droidcrew:design` if the app has no design system yet. Do not commit.
