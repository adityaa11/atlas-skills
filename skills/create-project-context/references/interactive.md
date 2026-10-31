# Interactive chat protocol

Use this protocol to make Project Context creation feel like a guided form
inside the conversation.

## 1. Start with an assessment board

After inspecting available sources, show a compact board. Use these statuses:

- `complete` - supported and usable;
- `partial` - some useful information exists but clarification is needed;
- `missing` - no usable information found;
- `conflicted` - credible sources disagree;
- `to-confirm` - a role or decision is material but not established; and
- `not-applicable` - explicitly irrelevant to this project.

Use the lenses that fit the project. A typical first board is:

```text
PROJECT CONTEXT READINESS

[complete] Project identity and rationale
[partial]  Objectives and outcomes
[missing]  Scope and non-goals
[to-confirm] Decision authority
[complete] Current and target state
[partial]  Constraints and dependencies
[missing]  Success / acceptance basis
[complete] Evidence and contradictions

Blocking gaps: 3
Proposed status: needs-review
```

Do not pretend the board is a numeric quality score. It is a decision aid that
shows what needs attention.

## 2. Ask focused questions

Prioritize questions in this order:

1. project identity, problem, and objective;
2. scope and non-goals;
3. sponsor, owner, and decision authority;
4. current state, target state, and material boundary;
5. constraints, dependencies, and obligations; and
6. success or acceptance basis.

Ask no more than three related questions in one round unless the user asks to
see the full questionnaire. Do not ask for technical choices, package names,
architecture, implementation tasks, or ticket detail. If a technical detail is
actually a current project constraint, ask only for the project-level meaning
and provenance of that constraint.

When a question is non-blocking, label it as optional, deferred, or
`to-confirm` rather than treating it as a blocker.

## 3. Reconcile every answer

After each user answer:

1. map it to the relevant project lens;
2. classify its claim state;
3. update the board;
4. identify any new contradiction or scope impact; and
5. ask the next smallest set of high-value questions.

If the user says to skip something, record the appropriate classification and
continue. Do not repeatedly ask the same question unless new evidence changes
its importance.

## 4. Preview before writing

When no blocking project question remains, show a concise preview:

```text
PROJECT CONTEXT PREVIEW

Status: ready
Will update:
- .agents/context/index.md
- .agents/context/project.md

Still deferred:
- [non-blocking item]

Please confirm, revise a section, or continue investigating.
```

If the user requests a revision, update the affected claim and re-run the
readiness check. If the user confirms, write only the approved Project Context
and index.

## 5. Support natural navigation

Recognize natural language equivalents of:

- "what is missing?" - show the board and blockers;
- "continue" - ask the next focused questions;
- "skip" - classify the current item as deferred or `to-confirm`;
- "review" - show the current preview without writing;
- "revise the objective" - reopen that lens;
- "save" - write only after preview and confirmation; and
- "start over" - discard the in-memory draft, not existing files, unless the
  user explicitly asks to replace them.

The user should never need to know the internal lens names or file schema to
complete the interaction.
