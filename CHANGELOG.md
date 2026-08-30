# Changelog

All notable changes to droidCrew are documented here.
This project follows [Semantic Versioning](https://semver.org/).

## [1.0.0] — 2026-08-31

First public release.

### The crew
- **Orchestrator** (opus) — plans items, routes design work, writes the single prompt the Coder
  executes, closes the loop on results and QA. Owns `PRODUCT.md`, the backlog and `STATUS.md`.
  Never writes application code.
- **Designer** (opus) — owns `DESIGN.md` in Material 3 role vocabulary, writes per-feature specs,
  drives Claude Design over MCP with a spec-only fallback, and reviews built UI on a device.
- **Coder** (sonnet) — the only agent that writes application code, under strict scope discipline.
- **QA** (opus) — dispatches four independent reviewers over one diff and merges their findings.

### Commands
`/droidcrew:setup`, `:plan`, `:design`, `:code`, `:qa`, `:status`.

### Notable behaviour
- **Tiered skill routing.** Installed skills are discovered and split into Always (capped at three
  per agent), On demand (read when a stated trigger fires), and Not routed.
- **Discovery greps are never primed.** Prompts state the rule to measure, never the expected count,
  so a verification step cannot agree with an answer it was handed.
- **Tautological-test detection.** For any defect tests should have caught, QA re-runs the suite; a
  green result is reported as its own finding.
- **Evidence over majority.** The QA lead overturns agreeing reviewers when it holds evidence they
  lacked, and attributes out-of-band tree changes by mtime before blaming the Coder.
- **RED before GREEN on corrections.** A test written to cover a defect must be watched failing
  against the unfixed code, with the RED output recorded.
- **Write guard.** A `PreToolUse` hook keeps source edits inside the `code` stage. Works with or
  without `python3`, and warns rather than silently allowing when it cannot read a path.
