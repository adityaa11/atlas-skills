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

Decide whether the context needs a bundle. Use one when several milestones need
detailed work-package maps or architecture/decision material will evolve
independently; retain a single document only for genuinely small, one-milestone
work. Read the compact implementation entry point first when a bundle exists.

Build an in-memory map of project outcomes, scope boundaries, constraints,
stack decisions, affected areas, dependencies, and evidence gaps. Preserve
stable decisions during a refresh and mark changed source claims as stale or
conflicted instead of silently overwriting them.

Classify the project from repository evidence as `greenfield`, `existing-code`,
or `hybrid`. For existing-code or hybrid work, build only the current-state map
needed for safe sequencing: active capabilities, entry points/interfaces,
data/state, runtime boundaries, and behavior that must be preserved, replaced,
or retired. Do not assume a repository is greenfield merely because it is
sparse or contains prototypes.

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

Derive the Architecture Overview that explains how the approved stack can
realize that end product. Identify material implementation-shape choices and
record them as confirmed, proposed, deferred, blocked, or superseded. Surface
only decisions that affect milestone order, work-package boundaries, interfaces,
verification, or later work; leave ticket-local design for ticket creation.

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
[partial]  Project-state classification and current-state preservation map
[partial]  Stack decisions and repository boundaries
[partial]  Architecture Overview and Decision Register
[partial]  Milestone outcomes and dependency shape
[to-confirm] Material decisions and their implementation impact
[partial]  Integration, data, and transition impact
[missing]  Research for compatibility-sensitive choice
[partial]  Verification and operational evidence
[partial]  Work-package map and ticket-generation readiness

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
4. a material decision whose answer changes scope, sequencing, interface, or
   verification;
5. a phase dependency, transition, or compatibility constraint;
6. a verification or operational expectation; and
7. a research question whose answer may change the plan.

Once milestone shape is sufficiently clear, decompose every milestone into
candidate work packages. Ask about work-package granularity only when it would
materially change the result; otherwise use small, independently reviewable
implementation units. This is execution planning, not a request for estimates,
sprint dates, or assignees.

When a decision needs the user's answer, show an **Approval-needed** list with
the decision, why it matters, affected milestone or package, bounded options
or evidence, and safe deferral consequence. Do not assign an owner, approver,
or professional role.

When a ticket or implementation result changes a recorded architecture
decision, refresh the affected Architecture Overview, decision record,
dependency graph, and downstream milestones before planning their tickets.

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

Project state: [greenfield | existing-code | hybrid] — [evidence]
Current-state transition: [not applicable | preservation/replacement summary]

Target end product:
- [product form and primary users]
- [essential capabilities and acceptance signals]
- [boundaries and quality expectations]

Milestone-based phases:
1. [milestone outcome] -> [project/product result] -> [acceptance gate]
2. [milestone outcome] -> [project/product result] -> [acceptance gate]

Material decisions: [confirmed / proposed / deferred]
Architecture Overview: [material boundaries and seams]
Decision Register: [new, resolved, deferred, or superseded decisions]
Research findings: [decision-relevant summary]
Still deferred: [items and revisit triggers]

Candidate work packages: [summary at <granularity>]
Dependency shape: [sequence and parallel work]
Fixture replacement map: [pairs and preserved invariants, if applicable]
Ticket-generation readiness: [ready | not-ready and gaps]
Context layout: [single document | bundle; entry point and selected documents]

Approval-needed: [only source-supported unresolved decisions, if any]

Will update:
- .agents/context/implementation.md [entry point or single document]
- .agents/context/implementation/[architecture, decisions, verification, milestones...]
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
- "change work-package granularity" - revise the execution-planning map and
  rerun the ticket-generation readiness test;
- "defer" - record the item with a revisit trigger;
- "review" - show the current preview without writing;
- "save" - write only after preview and confirmation; and
- "start over" - discard the in-memory draft, not existing files, unless the
  user explicitly asks to replace them.

The user should not need to know the internal contract vocabulary to steer the
work.
