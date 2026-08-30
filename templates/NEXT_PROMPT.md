# NEXT_PROMPT — <item id> <title>

**Backlog item:** · **Written:** YYYY-MM-DD · **Branch:**

## What this is
## What this does NOT cover

## Read the following files in full before writing any code
1. `CLAUDE.md`
2. `docs/droidcrew/PRODUCT.md` — Non-negotiables
3. `docs/droidcrew/DESIGN.md` §…
4. Skills (Coder rows of `docs/droidcrew/skills.md`): …
5. Files: …

## Design spec (inline)

## Part 1 — 
**File:** · **Rule:** · **Do not:**

## Tests
| Area | What must be asserted |
Expected count: N–M from a verified baseline of B.

## Verification — run these exactly
```bash
./gradlew :app:assembleDebug --rerun-tasks
./gradlew :app:testDebugUnitTest --rerun-tasks
```
Greps to report: the standard six (discovery — state the rule, never the expected count)
Assertion greps (this change is what makes them true — expected value + reason):
| Grep | Expected | Because |

## Device check   (omit if none)

## Blockers to raise rather than resolve

## Git
Commit nothing, push nothing, create no branches. Leave the tree dirty and describe what changed.
