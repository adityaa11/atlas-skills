# Interactive Implementation Context protocol

Use the conversation as a guided planning session. The user should be able to
answer in ordinary language such as "keep this phase", "research the queue
option", "that is out of scope", "show blockers", "defer the migration", or
"save".

## 1. Inspect, map, and review the end product

Before asking questions, locate and inspect:

- the canonical context index;
- Project Context;
- Stack Context, if available;
- repository guidance and high-signal implementation evidence; and
- existing Implementation Context, if this is a refresh.

Build an in-memory map of project outcomes, scope boundaries, constraints,
stack decisions, affected areas, dependencies, and evidence gaps. Preserve
stable decisions during a refresh and mark changed source claims as stale or
conflicted instead of silently overwriting them.

Before proposing phases, produce a concise target end-product review from the
Project Context and Stack Context together:

- end product or service form;
- primary users, stakeholders, or consuming systems;
- essential capabilities and workflows;
- system boundary and external dependencies;
- quality, security, privacy, performance, reliability, and operational
  expectations that shape implementation; and
- product-level acceptance signals.

Show which parts are documented, inferred, unknown, or conflicted. Compare the
Project Context's intended result with what the Stack Context can support. If
the contexts describe different products or the target result is materially
unclear, treat that as a blocker before phase decomposition.

## 2. Start with a readiness board

Show a compact board after inspection. Use these statuses:

- `complete` - enough evidence exists for the current decision;
- `partial` - a useful basis exists but clarification or research may change
  the plan;
- `missing` - no usable basis was found;
- `conflicted` - credible sources disagree;
- `to-confirm` - authority or a material decision is not established;
- `blocked` - the phase cannot safely proceed; and
- `not-applicable` - the concern does not belong to this project.

Example:

```text
IMPLEMENTATION CONTEXT READINESS

[complete] Target end product reviewed from Project and Stack Context
[complete] Project outcomes mapped to implementation outcomes
[partial]  Stack decisions and repository boundaries
[partial]  Milestone outcomes and dependency shape
[to-confirm] Decision authority and phase approvals
[partial]  Integration, data, and transition impact
[missing]  Research for compatibility-sensitive choice
[partial]  Verification and operational evidence

Blocking gaps: 1
Proposed status: needs-review
```

This is a decision aid, not a numeric score. State which gap is truly
blocking and which can remain deferred.

## 3. Ask focused questions

Ask no more than three related questions in one round. Prioritize:

1. a missing or conflicting end-product capability, user, boundary, or
   acceptance signal;
2. a missing Project Context boundary or outcome that changes phase scope;
3. a Stack Context or repository fact that changes product feasibility or
   sequencing;
4. an authority or approval boundary for a material decision;
5. a phase dependency, transition, or compatibility constraint;
6. a verification or operational expectation; and
7. a research question whose answer may change the plan.

Do not ask for every class, endpoint, package, ticket, or estimate. Capture
those only when the user explicitly asks for implementation-level detail and
the detail is necessary to resolve a decision.

## 4. Reconcile each answer

After each user answer:

1. map it to a project outcome, phase, decision, research item, or risk;
2. classify the claim state;
3. update the readiness board;
4. identify contradictions, scope effects, and new dependencies; and
5. ask the next smallest set of high-value questions.

If the user says "skip", classify the item as `deferred`, `to-confirm`, or
`unknown` with a trigger for revisiting it. Do not repeatedly ask the same
question unless new evidence changes its materiality.

## 5. Research and compare in the chat

When a decision needs research, state:

- the question being researched;
- why it affects a phase or verification gate;
- sources to inspect;
- the decision it may change; and
- the stopping condition for research.

Return a concise comparison with the finding, evidence state, implementation
impact, confidence, and unresolved uncertainty. Do not research indefinitely
or present a favorite option as confirmed without authority.

## 6. Preview before writing

When no blocking question remains, show a preview such as:

```text
IMPLEMENTATION CONTEXT PREVIEW

Status: ready
Inputs:
- .agents/context/project.md
- .agents/context/stack.md
- repository evidence: [paths]

Target end product:
- [product form and primary users]
- [essential capabilities and acceptance signals]
- [boundaries and quality expectations]

Milestone-based phases:
1. [milestone outcome] -> [project/product result] -> [acceptance gate]
2. [milestone outcome] -> [project/product result] -> [acceptance gate]

Material decisions: [confirmed / proposed / deferred]
Research findings: [decision-relevant summary]
Still deferred: [items and revisit triggers]

Will update:
- .agents/context/implementation.md
- .agents/context/index.md

Please confirm, revise a phase, continue researching, or keep this as draft.
```

If the user requests a revision, update only the affected map and rerun the
readiness check. If the user confirms, write the approved artifact and index
entry. If no canonical index exists, follow repository convention; otherwise
use `.agents/context/implementation.md` and the established index.

## 7. Support natural navigation

Recognize natural equivalents of:

- "what is missing?" - show the board and blockers;
- "continue" - ask the next focused questions;
- "research this" - run or plan the bounded research protocol;
- "compare" - show the smallest useful decision comparison;
- "split/merge this phase" - revise milestone outcomes, dependencies, and
  acceptance gates;
- "defer" - record the item with a revisit trigger;
- "review" - show the current preview without writing;
- "save" - write only after preview and confirmation; and
- "start over" - discard the in-memory draft, not existing files, unless the
  user explicitly asks to replace them.

The user should not need to know the internal contract vocabulary to steer the
work.
