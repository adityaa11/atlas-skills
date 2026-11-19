# Interactive Stack Context protocol

Use the conversation as a guided decision workflow. The user should be able to
answer in ordinary language such as "select this", "keep it experimental",
"defer versions", "compare these options", "review", or "save".

## 1. Start with an assessment board

After inspecting the Project Context and relevant evidence, show a compact
board. Use statuses such as:

- `complete` - enough information to decide;
- `partial` - useful information exists, but clarification may change the
  choice;
- `missing` - no usable basis found;
- `conflicted` - credible sources disagree;
- `to-confirm` - authority or a material constraint is not established; and
- `not-applicable` - the capability does not belong in this project.

Example:

```text
STACK CONTEXT READINESS

[complete] Project needs mapped to stack capabilities
[partial] Runtime and development constraints
[to-confirm] Operational/support boundary
[complete] Candidate comparison basis
[partial] Licensing and long-term support

Blocking decisions: 1
Proposed status: needs-review
```

This is a decision aid, not a numerical score.

## 2. Ask focused questions

Ask only questions that can change a technology selection or its status. Good
question areas include:

1. missing project constraints that affect compatibility;
2. baseline versus experimental expectations;
3. support, licensing, security, or operational obligations;
4. whether a choice is reversible enough to defer; and
5. who has authority to approve the stack baseline.

Do not ask for folder layouts, endpoint shapes, class design, detailed
deployment steps, or implementation tickets.

## 3. Compare and simulate

For each meaningful candidate:

- state the project need it addresses;
- compare it with the smallest useful set of alternatives;
- describe a short future implementation scenario;
- identify what would be measured or verified; and
- record the trade-off and residual uncertainty.

The simulation should answer "what would implementation need this for?" It
must not answer "which files or tasks should be created?".

## 4. Preview before writing

When no blocking stack question remains, show a concise preview:

```text
STACK CONTEXT PREVIEW

Status: ready
Will update:
- .atlas/contexts/stack.md
- .atlas/contexts/index.md

Selected: [technology choices]
Experimental: [bounded candidates]
Deferred: [non-blocking decisions]
Implementation Context will decide: [details]

Please confirm, revise a choice, or continue investigating.
```

If the user requests a revision, update the affected decision and rerun the
readiness check. If the user confirms, write only the approved Stack Context
and index entry.

## 5. Finish with a handoff

Report what was selected, what was simulated, what remains deferred, and what
Implementation Context is allowed to decide next. Do not imply that the
simulation is proof of implementation feasibility; it is a compact way to
surface likely needs and trade-offs before implementation work begins.
