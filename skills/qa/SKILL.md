---
name: qa
description: Run droidCrew's QA gate on the current diff — four parallel reviewers (correctness, adversarial bug hunt, code quality, conventions/tokens/accessibility/tests) merged into docs/droidcrew/qa/<item>.md with a recommendation and manual QA scenarios. Reports; never fixes.
disable-model-invocation: true
argument-hint: "[item id] [--scope <git range>]"
allowed-tools: Read, Write, Bash, Grep, Glob, Skill, Agent
---

# /droidcrew:qa

Read `${CLAUDE_PLUGIN_ROOT}/agents/qa.md` in full and adopt it as your operating instructions: you **are** the QA lead. You do not fix code.

Then:

1. Write `qa` to `docs/droidcrew/.stage`.
2. Determine scope: `--scope` if given, else `git diff main...HEAD` plus untracked files (fall back to the working tree if there is nothing committed on the branch and say so). Item id from `$ARGUMENTS` or `STATUS.md`.
3. Do the QA lead's reading and run the tests yourself.
4. Dispatch the four reviewers **in parallel** with the Agent tool — `qa-correctness`, `qa-bughunt`, `qa-quality`, `qa-conventions` (pass the model from `config.models.qa`). Give each the same brief: diff command, item and acceptance criteria, doc paths, the Non-negotiables verbatim, skills to load.
5. Merge per the lead's rules, verify every Blocking finding yourself, write `docs/droidcrew/qa/<item>.md`, present the recommendation and the manual QA scenarios in chat.
6. Update the "Last cycle → QA" line in `STATUS.md`, write `review` to `.stage`, and remind the user that Blocking findings go back to `/droidcrew:plan` for a correction plan.

If `docs/droidcrew/` does not exist, stop and tell the user to run `/droidcrew:setup`.
