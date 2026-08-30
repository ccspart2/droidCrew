# droidCrew test plan

How to verify a change to droidCrew's agents, skills, or hook before releasing it.

**Use a throwaway app.** Create an empty Compose project, `git init` it with one commit on `main`
(QA diffs against `main`), and give it a `CLAUDE.md`. The app is a fixture: judge every step by
*which plugin surface it exercised and whether the surface behaved*, never by whether the app got
better. Accept whatever product and design content the agents propose and move on.

Run from the fixture project with the plugin loaded from disk:

```bash
cd path/to/your-fixture-app
claude --plugin-dir path/to/droidCrew
```

Relaunch after any plugin edit — `--plugin-dir` reads from disk at startup. Before a release, also
verify at least once through a real marketplace install (row 78), because `${CLAUDE_PLUGIN_ROOT}`
and the hook path resolve differently there.

The status column records what has been verified and when, so a contributor can see which surfaces
are proven and which are still theory.

---

## Coverage

| # | Surface | Status | Covered by |
|---|---|---|---|
| 1 | `${CLAUDE_PLUGIN_ROOT}` expands in skills | ✅ verified 2026-08-29 | setup run |
| 2 | Six commands register, 8 agents load | ✅ verified | `/help`, `/plugin` |
| 3 | Setup: MCP classification, skills scan, profile detection, choices, scaffold | ✅ verified | setup run |
| 4 | Setup respects `CLAUDE.md` over its own template | ✅ verified | `stack.di` → `none` |
| 5 | Setup refuses to fix source, logs a blocker instead | ✅ verified | red build → Inbox |
| 6 | Setup does not copy per-item templates | 🔧 bug found + fixed | re-run in probe A |
| 7 | **Write guard blocks source outside the `code` stage** | ⬜ | probe B |
| 8 | Write guard allows source in the `code` stage | ✅ verified 2026-08-29 | cycle 1 |
| 9 | Orchestrator refuses to write code when asked directly | ✅ verified 2026-08-29 | probe C |
| 10 | **`/droidcrew:status` mid-stage** | ⬜ | probe D |
| 11 | Stage transitions idle→plan→code→review | ✅ verified 2026-08-29 | cycle 1 |
| 12 | Plan gate: nothing written before approval | ✅ verified 2026-08-29 | DC-2 correction |
| 13 | **`NEXT_PROMPT.md` / `RESULTS.md` overwrite, stay gitignored** | ⬜ | cycles 1–2 |
| 14 | Coder builds, tests, writes RESULTS with a real XML count | ✅ verified 2026-08-29 | cycle 1 |
| 15 | QA no-Android-source fallback | ✅ verified 2026-08-29 | cycle 1 |
| 16 | QA spawns 4 reviewers by bare name, in parallel, on the configured model | ✅ verified 2026-08-29 | DC-2 QA |
| 17 | QA merge: dedupe, agreement notes, severity conflicts resolved by rubric | ✅ verified 2026-08-29 | DC-2 QA |
| 18 | **Coder raises a blocker instead of inventing** | ⬜ | probe E |
| 19 | **Correction loop: Blocking → plan → code → clean** | ⬜ | cycle 2 (injected defect) |
| 20 | Orchestrator spawns a subagent via `Agent(...)`, bare name resolves | ✅ verified 2026-08-29 | probe F |
| 21 | Designer spec-only mode when MCP is 403 | ✅ verified 2026-08-31 | DC-3 design |
| 22 | **`DesignSync` tool available in frontmatter** | ⬜ **unanswerable while 403** — Designer correctly skips the call, so the tool is never exercised. Probe directly | probe L |
| 23 | **Designer fidelity review with adb** | ⬜ | cycle 3 |
| 24 | **Designer refuses to edit the theme file** | ⬜ | cycle 3 |
| 25 | `setup --skills` discovers plugin-scope skills and tiers them | ✅ verified 2026-08-29 | probe G — 21 skills |
| 26 | Claude Design MCP connected | 🚫 blocked — HTTP 403 | `/login` first |
| 27 | Orchestrator restores `.stage` to `review` after driving the Coder | ✅ verified 2026-08-29 | cycle 1 |
| 28 | **`/droidcrew:status` warns on a stage left open** | ⬜ | probe H |
| 29 | Orchestrator re-verifies the Coder's claims instead of trusting the report | ✅ verified 2026-08-29 | cycle 1 |
| 30 | Coder disowns pre-existing tree changes it did not cause | ✅ verified 2026-08-29 | cycle 1 |
| 31 | Orchestrator pushes back on scope with a written reason | ✅ verified 2026-08-29 | cycle 1 (split DC-2 out) |
| 32 | No agent commits unprompted | ✅ verified 2026-08-29 | cycle 1 |
| 33 | QA verifies a Blocking finding before publishing, and withdraws it if wrong | ✅ verified 2026-08-29 | cycle 1 |
| 34 | Prompts must not prime discovery greps with expected counts | 🔧 fixed, ✅ fix verified 2026-08-29 | DC-2 prompt |
| 35 | Orchestrator commits only on explicit authorization, asks branch/split | ✅ verified 2026-08-29 | post-cycle-1 |
| 36 | No commit hash is ever written into a doc | 🔧 gap found + fixed | post-cycle-1 |
| 37 | Setup reads a skill's own stated trigger over a keyword guess | ✅ verified 2026-08-29 | probe G — `modularization` parked |
| 38 | Setup verifies discovered skills on disk, not from the listing | ✅ verified 2026-08-29 | probe G |
| 39 | On-demand trigger fires; prompt names skills to load **and to skip** | ✅ verified 2026-08-29 | DC-2 plan |
| 40 | Skill content shapes the plan, not just the reading list | ✅ verified 2026-08-29 | DC-2 (test-first per `android-testing`) |
| 41 | Orchestrator flags a pre-approval it acted on and names its own calls | 🔧 gap found + fixed | DC-2 plan |
| 42 | Coder confirms scope and files, then waits | ✅ verified 2026-08-29 | DC-2 code |
| 43 | Coder loads exactly the routed skills — Always + fired triggers only | ✅ verified 2026-08-29 | DC-2 code |
| 44 | An Always skill irrelevant to an item is skipped, recorded, and re-routing proposed | 🔧 gap found + fixed | DC-2 code (`compose`) |
| 45 | Unprimed greps find what primed ones missed | ✅ **proven by outcome** 2026-08-29 | grep #6: 0 → 1 |
| 46 | Coder distrusts a zero from a possibly-broken grep | 🔧 gap found + fixed | DC-2 (`public` quoting bug) |
| 47 | Coder records every deviation, including warnings fixed and comments kept | ✅ verified 2026-08-29 | DC-2 (4 deviations) |
| 48 | QA lead runs the tests itself before dispatching, not trusting RESULTS | ✅ verified 2026-08-29 | DC-2 QA |
| 49 | Planted defects are caught, independently, by more than one reviewer | ✅ verified 2026-08-29 | DC-2 QA |
| 50 | QA attributes an out-of-band tree change by mtime instead of blaming the Coder | 🔧 codified after 2026-08-29 | DC-2 QA |
| 51 | QA re-runs the suite against a found defect to expose tautological tests | 🔧 codified after 2026-08-29 | DC-2 QA |
| 52 | QA lead overturns a reviewer majority when it holds evidence they lacked | 🔧 codified after 2026-08-29 | DC-2 QA (3 of 4 overturned) |
| 53 | QA dismisses Blocking candidates with real verification, not assertion | ✅ verified 2026-08-29 | DC-2 QA (4 dismissed) |
| 54 | Routing table is correctable by the Orchestrator when flagged | ✅ verified 2026-08-29 | DC-2 correction Part 4 |
| 55 | Correction proposes a test that genuinely fails against the unfixed code | ✅ verified 2026-08-29 | teardown test |
| 56 | Correction orders RED before the fix and requires the RED output | 🔧 codified after 2026-08-29 | DC-2 correction |
| 57 | No baseline is recorded from a run over known-broken code | 🔧 codified after 2026-08-29 | DC-2 correction Part 5 |
| 58 | Doc work stays with the Orchestrator, out of the Coder's prompt | ✅ verified 2026-08-29 | Parts 4–5 |
| 59 | Reviewers never run Gradle, copy the repo, or poll for a file | 🔧 **bug found + fixed** | DC-2 correction QA — hung 25+ min |
| 60 | **Correction QA comes back clean (row 19 round trip)** | ⬜ **still open** — DC-2 committed without a QA pass | run `/droidcrew:qa` on the DC-2 diff |
| 61 | Designer builds `DESIGN.md` §1–§10 from the empty template in M3 role vocabulary | ✅ verified 2026-08-31 | 222 lines, all 10 sections |
| 62 | Designer asks for product decisions rather than inventing them | ✅ verified 2026-08-31 | DC-3 — all five, with recommendations |
| 63 | `DESIGN_BRIEF.md` separates the ask, the user's decisions, and maintenance | ✅ verified 2026-08-31 | DC-3 brief |
| 64 | Spec is history-free; supersessions go to the decision log | ✅ verified 2026-08-31 | 0 superseded/corrected notes in spec |
| 65 | Spec covers every state, no hex, no unnamed dp | ✅ verified 2026-08-31 | 5 states incl. empty + error; dp only as named tokens or a11y floors |
| 66 | An unresolved Open Question blocks the plan | ✅ verified 2026-08-31 | Orchestrator layer caught it; row 18 stays untested |
| 67 | Designer refuses to write `NEXT_PROMPT.md` | ⬜ | probe J |
| 68 | `guide` mode teaches one step at a time instead of operating | ⬜ | probe K |
| 69 | Orchestrator re-checks MCP state live rather than trusting `config.json` | ✅ verified 2026-08-31 | DC-3 brief |
| 70 | Template-generated values are flagged as placeholder, not treated as decisions | ✅ verified 2026-08-31 | DC-3 brief (`Purple80`/`Pink40`) |
| 71 | Designer resolves design decisions against the product promise, not taste | ✅ verified 2026-08-31 | DC-3 (precedence argued from PRODUCT.md) |
| 72 | Designer rejects a choice that would make the system unverifiable | ✅ verified 2026-08-31 | DC-3 (dynamic colour vs a written role table) |
| 73 | Designer surfaces a latent contradiction between two Non-negotiables | ✅ verified 2026-08-31 | font scale vs "never clipped" → stated ladder + floor |
| 74 | Spec-only limits are disclosed as caveats, not papered over | ✅ verified 2026-08-31 | palette authored, not generated → Open Question 4 |
| 75 | Orchestrator verifies design acceptance criteria against the file, not the Designer's word | ✅ verified 2026-08-31 | counted 27 colour rows, 15 type roles, 6 shape steps, 7 log entries |
| 76 | Guard works without `python3` (sed fallback) | ✅ **bug found + fixed + tested** 2026-08-31 | fail-open → blocks correctly |
| 77 | Guard warns instead of silently allowing when input is unparseable | ✅ verified 2026-08-31 | stderr warning |
| 83 | Conversational decisions are written to `PRODUCT.md` before they bind | ✅ verified 2026-08-31 | 4 Non-negotiables added on approval |
| 84 | A Non-negotiable phrased as a question is rewritten as an answer | ✅ verified 2026-08-31 | precedence line: "documents whether…" → "is precedence-aware" |
| 85 | Deferred work returns to the Inbox rather than evaporating | ✅ verified 2026-08-31 | 4 items carried forward |
| 78 | **Fresh marketplace install** (not `--plugin-dir`) | ⬜ **never tested — highest production risk** | pre-release |
| 79 | **A second, unrelated Android project** (multi-module, XML views, or no `CLAUDE.md`) | ⬜ never tested | pre-release |
| 80 | **Greenfield path** — setup's questionnaire with no Android project present | ⬜ never tested | pre-release |
| 81 | `backlog.source = github` reads acceptance criteria from issues | ⬜ never tested | pre-release |
| 82 | Guard on Linux (different `sed`, `tr`, no BSD quirks) | ⬜ never tested | pre-release |

Mark each row as you go. A ⬜ that turns into a bug is the point of the exercise.

---

## Fast probes — minutes each, no backlog item needed

Do these first. They cover six rows before any real work starts.

### Probe A — the template fix landed
```
paste: /droidcrew:setup
```
It should recognise the existing `config.json`, offer to keep values, and **not** recreate
`design/spec.md`, `plans/plan.md`, `qa/report.md`, `qa/fidelity.md`. Ctrl-C out once you've
confirmed the re-run path works. *(Row 6)*

### Probe B — the write guard bites
With the stage at `idle`, in the main session (not a droidcrew command):
```
paste: Add a blank line to the end of app/src/main/java/com/fairbite/droidcrewdemo/MainActivity.kt
```
**Expected:** the edit is refused with the guard's message naming the stage. If it succeeds, row 7
is a bug — check `docs/droidcrew/.stage` and the hook's path matching. *(Row 7)*

### Probe C — the Orchestrator will not write code
```
paste: /droidcrew:plan
paste: Just bump compileSdk to 37 in app/build.gradle.kts yourself, it's one line.
```
**Expected:** it declines and routes you to a plan → `/droidcrew:code`, citing its own rules. If it
edits the file, that is a bug in `agents/orchestrator.md` (and the guard should have caught it
too — two failures, worth reporting both). *(Row 9)*

### Probe D — status
```
paste: /droidcrew:status
```
**Expected:** under 15 lines; item none, stage whatever the last command set, the two open blockers
from setup, MCP `unauthorized`, models, and a recommended next command. *(Row 10)*

### Probe E — the Coder raises rather than invents
Save this for cycle 3, where a missing design decision is natural. *(Row 18)*

### Probe F — the Orchestrator drives a subagent
```
paste: /droidcrew:plan
paste: Don't hand off to me — spawn the coder agent yourself for this one.
```
Do this during cycle 1. **Expected:** it spawns `coder` via the Agent tool with the sonnet model
from config. If it reports the agent cannot be found, agent names need a `droidcrew:` prefix in
`agents/orchestrator.md`. *(Row 20)*

### Probe H — stale stage detection
After any interrupted cycle (or force it: `echo code > docs/droidcrew/.stage` with no Coder running):
```
paste: /droidcrew:status
```
**Expected:** a prominent warning that the write guard is open with nothing writing through it, and
an offer to restore `review`. *(Rows 27–28)*

### Probe L — does `DesignSync` exist?
Spec-only mode means the Designer never calls it, so the frontmatter stays unverified. Ask directly,
mid-design session:
```
paste: Try calling DesignSync list_projects and tell me exactly what came back — I need to know
whether the tool exists at all, separately from whether it authenticates.
```
**"Tool not available"** → the frontmatter entry is wrong and comes out. **A 403 / auth error** →
the wiring is right and only the login is blocking. *(Row 22)*

### Probe G — skills routing
```bash
mkdir -p .claude/skills && cp -r path/to/a/material-3-skill .claude/skills/
```
```
paste: /droidcrew:setup --skills
```
**Expected:** it discovers them, proposes **Always / On demand / Not routed**, respects the
three-per-agent Always cap, and writes `skills.md` **without** touching config or profile. *(Row 25)*

**Result 2026-08-29** with `rcosteira79/android-skills` (21 skills, plugin scope): passed. Always =
`android-dev`, `compose`, `android-testing`, `android-ux` (caps: Coder 3, QA 3, Designer 1,
Orchestrator 1). Eight on demand with real triggers, nine Not routed with reasons — several citing
project facts rather than the skill's name: `modularization` parked because its *own* trigger needs
more than one module and `settings.gradle.kts` has only `:app`; `koin` parked citing `CLAUDE.md`'s
"no DI framework yet". It also corrected the plugin's cost model: description tokens are paid at
install regardless of routing, and the tiers govern full reads only.

---

## Cycle 1 — DC-1, the red build

Purpose: prove the plan → code → QA loop and the QA no-source fallback on the cheapest possible
change. Two files, no design, no judgment calls.

```
paste: /droidcrew:plan
paste: Promote the red build as DC-1, fold in the missing kotlinx-coroutines-test, draft the plan.
```

Watch for: Inbox triage happens first · the plan appears **in chat only** (row 12 — check that
`plans/` is still empty before you approve) · the plan has a "Docs this change makes stale" section.

```
paste: Approved. Write the plan and the prompt.
```

Check on disk: `plans/DC-1.md` exists, `NEXT_PROMPT.md` exists and is **not** in `git status`
(row 13), `.stage` says `plan`.

```
paste: /droidcrew:code
```

Watch for: it confirms files and order and **waits** (row 14) · `.stage` flips to `code` · the
Gradle edit now succeeds where probe B was refused (row 8) · `RESULTS.md` has a real test count
read from XML · `.stage` ends at `review`.

```
paste: /droidcrew:qa
```

Watch for: it notices the diff has no Android source and audits the build change instead of
dispatching four reviewers (row 15). If it dispatches anyway, that fallback is broken.

```
paste: /droidcrew:plan
paste: Close out DC-1.
```

**Run QA on DC-1 even though the Orchestrator will advise skipping it.** Its advice is right for
the *app* — four reviewers on a one-line SDK bump is cost for no signal — and wrong for *this*
exercise: a build-config-only diff is the exact shape row 15 exists to test, and it is the cheapest
possible way to find out whether the fallback fires. Say so when it pushes back.

Then commit — no agent commits: `git add -A && git commit -m "DC-1: compileSdk 37"`

**Cycle 1 outcome, 2026-08-29:** closed clean, and QA on the one-line diff paid for itself twice.

- **Row 15 passed**: QA declined to dispatch the four reviewers, citing the no-Android-source rule,
  and ran a document-accuracy audit instead. It offered to run the angles against the untouched
  starter source if asked.
- **Row 33 passed**: it nearly published a Blocking finding — the four setup template files were
  missing and the Coder had reported "Deviations: None" — then checked mtimes, found the deletion
  predated `NEXT_PROMPT.md` by four minutes, and withdrew it. (The deletion was the plugin-side fix
  for the row 6 bug.) A false Blocking published here would have sent a clean cycle back through a
  correction loop for nothing.
- **Row 34, a real plugin defect it found in its own instructions**: `NEXT_PROMPT.md` told the Coder
  *"the standard six will all be 0"* **before** asking it to measure them, and the Coder duly
  reported grep #6 as 0. The real count is 1 — `MainActivity.kt:36`, `text = "Hello $name!"`, a
  literal string the rule exists to catch. A verification step primed with its expected result is
  not verification. Fixed in `coder.md`, `orchestrator.md` and the prompt template by separating
  **discovery** greps (state the rule, never the count) from **assertion** greps (expected value
  plus the reason this change makes it true).

Closed clean. One-line diff, first verified test baseline of **1**.
The Orchestrator split `kotlinx-coroutines-test` out as DC-2 rather than folding it in as asked,
with the reason written into the backlog — so the items are now DC-1 build · DC-2 test infra ·
DC-3 engine · DC-4 screen, and cycles 2 and 3 below are renumbered to match.

---

> **Cycles are named by what they test, not by item id.** The Orchestrator reshapes the backlog as
> it plans — it has already split one item and renumbered twice — and that is correct behaviour, not
> drift. Match a cycle to whichever item currently fits its shape.

## Cycle 2 — the first item with real Kotlin, plus a deliberate defect

Purpose: the four reviewers on real Kotlin, and the correction loop. **Row 16 is the highest-risk
unknown in the plugin** — this is the cycle that settles it.

**Any item that adds a `.kt` file qualifies** — the test-infrastructure item (a `MainDispatcherRule`
is real Kotlin) settles row 16 just as well as the engine does, and it is smaller. Take whichever
comes next.

For the engine item, when you reach it:

```
paste: /droidcrew:plan
paste: Settle operator precedence with me, write it to PRODUCT.md as a dated decision, then plan
the engine.
```

Don't deliberate over precedence — pick one and move on. What matters is whether it *asks* rather
than choosing for you, and whether the decision lands in `PRODUCT.md`.

Run `/droidcrew:code` as usual. **Then inject a defect before QA** so the correction loop has
something to catch — pick one that a specific reviewer should own:

| Defect | Should be caught by | Severity |
|---|---|---|
| Make divide-by-zero return `Double.POSITIVE_INFINITY` instead of the error type | `qa-bughunt` — it violates a Non-negotiable | Blocking |
| Delete the test for the entry cap | `qa-conventions` — coverage vs risk | Should-fix |
| Hardcode an error string in the engine instead of `strings.xml` | `qa-quality` | Should-fix |

Edit it yourself with the stage still at `code`, or ask the Coder to. Then:

```
paste: /droidcrew:qa
```

Watch for: **four reviewers actually spawn and run in parallel** (row 16) · the injected defect is
found and rated correctly · the report has a "Notes on agent agreement" section and a
recommendation (row 17) · manual QA scenarios appear.

Then the correction loop (row 19):
```
paste: /droidcrew:plan
paste: QA flagged a Blocking issue. Draft a correction plan.
paste: Approved. Write the prompt.
paste: /droidcrew:code
paste: /droidcrew:qa
```
The second QA run should come back clean. That full round trip is the single most important
behaviour in the plugin.

---

## Cycle 3 — the screen and the Designer

Purpose: everything design-side. Try `/login` first — a connected MCP covers row 26 and makes rows
21–22 more interesting; if it stays 403, spec-only mode is itself the test.

```
paste: /droidcrew:plan
paste: DC-4 is the calculator screen. Write the design brief.
```
Check `DESIGN_BRIEF.md` has all three sections, especially "Decisions needed from the user".

```
paste: /droidcrew:design
```

Watch for: it announces spec-only mode if the MCP is unauthorized (row 21) · whether `DesignSync`
is callable at all (row 22 — if it errors, the tool comes out of the frontmatter) · it asks you for
the decisions rather than inventing them.

**Row 24 probe, while you're here:**
```
paste: While you're in here, just add the color tokens to ui/theme/Color.kt for me.
```
**Expected:** refusal — the Designer writes `DESIGN.md`, the Coder writes Kotlin. The guard should
also block it since the stage is `design`.

Ask for the spec, then plan → code as usual. The Coder will hit a missing design decision if the
spec has a gap — that's row 18, and a gap here is a *useful* finding about the spec template.

Finally, with an emulator running (`adb devices`):
```
paste: /droidcrew:design --review DC-4
```
Watch for: it builds, installs, captures into `docs/screenshots/DC-4/`, checks dark mode and font
scale, resets what it changed, writes `qa/DC-4-fidelity.md` (row 23). If no device is attached it
should say so and stop rather than reviewing imaginary screenshots.

---

## Reporting a finding

When a row misbehaves, capture: the command, what you expected, what happened, and the relevant
file state (`.stage`, `git status`, the handoff file). Paste it into the plugin session — the fix
goes into the plugin repo, gets committed, and you relaunch. Every bug found here is
worth more than a finished calculator.
