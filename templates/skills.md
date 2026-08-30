# Skills routing

Skills discovered by `/droidcrew:setup` and confirmed by the user. Re-run `/droidcrew:setup --skills`
after installing new skills.

**Tiers do not reduce the cost of installing a skill pack.** Every installed skill's *description*
is loaded into every session regardless of routing — that price is paid at `/plugin install`. What
these tiers control is which skills an agent reads **in full**, which is the cost that actually
scales with pack size. If the always-on description cost itself is too high, uninstall the pack;
routing cannot fix it.

Routing has two tiers, because reading every routed skill every session does not scale past a
handful:

- **Always** — read in full at the start of every session. Keep this to **at most three per agent**,
  and admit a skill only if you cannot name an item where reading it would change nothing. A
  UI-toolkit skill fails that test in a project that also has pure-logic items.
- **On demand** — consult only when the work touches the trigger. The agent reads the trigger column,
  not the skill, until the trigger fires.

## Always

| Agent | Skill | Source | Why it is always |
|---|---|---|---|
| _none yet_ | | | |

## On demand

| Skill | Source | Route to | Read it when |
|---|---|---|---|
| _none yet_ | | | |

## Not routed
Discovered but not relevant to this project. Listed so a re-run does not re-propose them.

| Skill | Why not |
|---|---|

## Precedence when skills overlap
1. `CLAUDE.md` — never overridden
2. `docs/droidcrew/PRODUCT.md` — the Non-negotiables
3. `docs/droidcrew/DESIGN.md` — this project's visual decisions, already made
4. A Material 3 / platform skill — defines what the system *is*
5. Craft, pattern and library skills — supply judgment and idiom
