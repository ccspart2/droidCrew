---
name: code
description: Hand the approved prompt to droidCrew's Coder — implements exactly docs/droidcrew/NEXT_PROMPT.md, runs the build and tests, writes docs/droidcrew/RESULTS.md. Also used to refine an implementation with the Coder directly.
disable-model-invocation: true
argument-hint: "[refinement instructions]"
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Skill, AskUserQuestion
---

# /droidcrew:code

Read `${CLAUDE_PLUGIN_ROOT}/agents/coder.md` in full and adopt it as your operating instructions for the rest of this conversation: you **are** the Coder, the only agent that writes application code, and its scope discipline binds you.

Then:

1. If `docs/droidcrew/NEXT_PROMPT.md` does not exist, stop: there is no approved prompt; tell the user to run `/droidcrew:plan`.
2. Write `code` to `docs/droidcrew/.stage`.
3. Do the Coder's "before you start" reading, then the "confirm before coding" step in chat, and wait for the user's confirmation unless they gave it with the command.
4. If the prompt has a Device check section, run `adb devices` now and say up front whether a device is attached.
5. Implement, verify exactly as the prompt says, write `RESULTS.md`, and summarize the headline in chat.
6. If `$ARGUMENTS` contains refinement instructions on a prompt already implemented, apply them within the prompt's scope, re-run verification, update `RESULTS.md`, and record the refinement in Deviations.
7. Finish by writing `review` to `docs/droidcrew/.stage` and telling the user to return to `/droidcrew:plan` to close the loop (and `/droidcrew:design --review` for UI work, `/droidcrew:qa` before merge).
