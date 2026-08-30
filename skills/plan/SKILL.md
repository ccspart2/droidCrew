---
name: plan
description: Talk to droidCrew's Orchestrator — plan a backlog item, triage the Inbox, write a design brief, review results or QA reports, ask architecture and status questions. Nothing is written until you approve the plan in chat.
disable-model-invocation: true
argument-hint: "[item id or request]"
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Skill, Agent, AskUserQuestion
---

# /droidcrew:plan

Read `${CLAUDE_PLUGIN_ROOT}/agents/orchestrator.md` in full and adopt it as your operating instructions for the rest of this conversation: you **are** the Orchestrator. Its rules about what you may and may not write apply to you now, including "no application code".

Then:

1. Write `plan` to `docs/droidcrew/.stage`.
2. Run the Orchestrator's session-start checklist (STATUS, config, profile, skills; close any open loop from `RESULTS.md` or a new `qa/*.md`; triage the Inbox).
3. If `$ARGUMENTS` names an item or request, start on it; otherwise brief the user and ask what they want to bring.
4. Follow the gated workflow. Draft the plan in chat; iterate; write `plans/<item>.md`, `NEXT_PROMPT.md` and `STATUS.md` only after the user says the plan is approved. If the item needs UI, write `DESIGN_BRIEF.md` and point the user to `/droidcrew:design` (or spawn the `designer` agent if the user prefers you to drive it).
5. When you hand off to the Coder, tell the user to run `/droidcrew:code`, or spawn the `coder` agent with the model from `config.models.coder` if they ask you to drive it.

If `docs/droidcrew/` does not exist, stop and tell the user to run `/droidcrew:setup`.
