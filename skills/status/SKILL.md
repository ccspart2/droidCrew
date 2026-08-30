---
name: status
description: Show droidCrew's pipeline state — current item and stage, what is pending your approval, open blockers, the latest results, QA and fidelity reports, and the recommended next command.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob
---

# /droidcrew:status

Read-only. Do not adopt any agent persona and do not modify files.

1. If `docs/droidcrew/` is missing, say so and point to `/droidcrew:setup`.
2. Read `docs/droidcrew/STATUS.md`, `.stage`, `config.json`; check for `DESIGN_BRIEF.md`, `NEXT_PROMPT.md`, `RESULTS.md` and their modification times relative to `STATUS.md`; list the latest files in `plans/`, `design/*/spec.md`, `qa/`.
3. Run `git status --short | head -20` and `git branch --show-current`.
4. **Stale-stage check.** If `.stage` is `code` but no Coder is running in this session, and
   either `RESULTS.md` is missing or older than `NEXT_PROMPT.md`, warn prominently: the write
   guard is open with nothing writing through it, which means a previous cycle was interrupted.
   Offer to restore the stage to `review`. Same warning for any stage other than `idle`/`review`
   whose owning artifact is missing.
5. Report in under 15 lines: item · stage · pending approval · blockers · newest artifact and whether it is newer than STATUS (i.e. a loop is open) · dirty files count · MCP state · models · **recommended next command** (`/droidcrew:plan` to close a loop or plan, `/droidcrew:design` for a pending brief, `/droidcrew:code` for a fresh prompt, `/droidcrew:qa` before merge).
