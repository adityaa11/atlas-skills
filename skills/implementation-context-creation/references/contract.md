# Implementation Context contract

This contract defines the semantic boundary and readiness test for an
Implementation Context. It is a reasoning guide, not a mandatory heading
layout. Combine or omit sections when that makes the implementation model
clearer.

## What Implementation Context owns

Implementation Context is the durable bridge between project intent and
execution. It explains how the project can be realized within its approved
scope and constraints.

It may define:

- a reviewed target end-product baseline derived from Project Context and
  Stack Context;
- a project-state classification (`greenfield`, `existing-code`, or `hybrid`)
  grounded in repository evidence;
- for existing-code or hybrid work, a current-state preservation/replacement
  map for material capabilities, interfaces, data/state, and runtime seams;
- traceability from Project Context outcomes and boundaries;
- inherited Stack Context decisions and implementation consequences;
- an Architecture Overview and Decision Register for material
  implementation-shape choices within the approved stack;
- milestone-based phase objectives, dependencies, entry/exit criteria, and
  handoffs;
- capability boundaries;
- conceptual component, interface, data, integration, and transition
  decisions;
- research questions, evidence, findings, confidence, and decision impact;
- verification, observability, security, privacy, and operational readiness
  expectations;
- source-documented decision constraints by phase;
- risks, assumptions, decision triggers, reversibility, and change control; and
- open questions and the execution-planning map.

It must define an execution-planning map: candidate work packages per milestone
and their dependencies, interfaces, acceptance evidence, exclusions, and
handoffs. This is the required bridge from related milestone work to later
granular ticket-set creation.

It must not become:

- a replacement for Project Context or Stack Context;
- a full software design specification when the project is not ready for that
  detail;
- an unapproved backlog, sprint plan, estimate, or individual assignment list;
- a record of research detached from decisions; or
- a collection of implementation claims without evidence or uncertainty.

## Context bundle contract

An Implementation Context may be a single document only when it is genuinely
small and has one bounded milestone. Prefer a bundle for multiple detailed
milestones or independently changing architecture/decision material.

The canonical implementation entry point is the compact routing index. It must
include:

- context ID, revision, status, project-state classification, and
  ticket-generation readiness;
- a `Read first` list for the current or requested work;
- current/next milestone, eligible packages, blocking decisions, and required
  predecessor evidence when known;
- a milestone registry with stable ID, status, path, direct dependencies, and
  read condition;
- a decision registry with stable ID, status, path or anchor, and affected
  milestones/packages; and
- change-routing rules for package/interface, decision, and source-context
  changes.

It must link rather than duplicate detailed architecture, decisions,
verification, and milestone work-package maps. The canonical global context
index links to this entry point, not every bundle member.

An agent reads the entry point first, then only the requested milestone, direct
dependencies, and documents named by the relevant registry rows. A full-bundle
scan is justified only when the index is stale, missing, or contradictory.
Every update reconciles the entry point with changed records and affected
statuses.

## Architecture overview and decision lifecycle

The Architecture Overview gives enough system-level design to keep milestone
and package work coherent. It must describe only material, evidence-backed
choices such as delivery/package or module boundaries, authoritative data and
trust ownership, interface/adapter seams, fixture/test strategy, integration
boundaries, and migration/transition posture. It does not prescribe exact file
layout, code structure, API payloads, schemas, or ticket-local algorithms.

The Decision Register records each material architecture decision with:

- stable decision ID and question;
- status: `confirmed`, `proposed`, `deferred`, `blocked`, or `superseded`;
- evidence and rationale;
- affected end-product capability, milestone, package, interface, or
  verification; and
- what it enables, blocks, or triggers for revisit.

At initial creation, include every decision needed to safely order milestones
and generate tickets for the next executable milestone. Fine-grained decisions
that do not affect those boundaries may remain deferred.

When downstream ticket design or implementation resolves, changes, or
invalidates a registered decision, refresh the Implementation Context before
generating dependent later tickets. Record the new or superseded decision,
reconcile affected package dependencies and verification, and mark the context
`stale` or affected milestones `revisiting` when the recorded plan is no
longer safe. Ticket-level work cannot silently redefine architecture that
affects later milestones.

## Traceability model

Every material phase or decision should be understandable through this chain:

```text
Target end product
  -> project outcome or constraint
  -> implementation objective
  -> milestone phase / capability slice
  -> technical or product decision
  -> verification evidence
  -> exit condition and next handoff
```

If a milestone phase cannot be traced to a project outcome, scope item,
constraint, dependency, or risk, mark it as proposed and ask whether it
belongs. If a project outcome has no milestone phase or explicit reason for
deferral, mark the gap.

The required execution-planning map extends the traceability chain:

```text
Project outcome -> milestone -> work package -> verification evidence
```

Every candidate work package must retain this trace; a package without it is
not ready to be generated as a ticket.

## Sequencing model

Order is a partial dependency graph, not a generic lifecycle. A package may
precede another only because it provides a required interface, decision,
trusted state, safety condition, preservation/compatibility boundary, or
verification basis. Packages without such an edge are parallel-safe unless
repository evidence identifies a shared constraint.

Use the project-state classification to choose the first work: greenfield work
starts from the smallest end-product capability or risk-reducing validation;
existing-code and hybrid work first establishes only the current-state facts
needed to preserve, replace, or retire live behavior safely. See
[milestone-ordering.md](milestone-ordering.md).

## Execution-planning map contract

This map is a required intermediate planning layer, not an approved backlog,
estimate, sprint plan, or assignment list.

For each milestone, provide an execution-planning map of candidate work
packages. Each package is one independently reviewable implementation unit and
has a stable ID, outcome, scope boundary, explicit exclusions, dependency IDs,
affected interfaces, acceptance evidence, and handoff. Record whether each
dependency is a required sequence, interface/decision prerequisite, or safe
parallel work, and provide a dependency graph or adjacency map that makes
sequence and parallelism visible. Package records are authoritative: every
graph edge must match a recorded dependency, and every recorded dependency must
appear in the graph.

For fixture-first work, name the fixture scenario in the package that creates
or uses it and name the later package that replaces it with a backend adapter.
Use `not applicable` when no fixture is involved; do not imply an adapter will
exist when it is unknown.

Provide a fixture-replacement map when fixtures are used:

```text
fixture package -> fixture scenario/interface -> backend replacement package -> invariant preserved
```

The intended package fields are planning inputs for a future ticket generator,
not ticket metadata to be approved now:

- stable ID and milestone/project-outcome trace;
- outcome, scope boundary, and exclusions;
- dependency IDs and relationship type;
- affected interfaces;
- existing behavior, data, or runtime boundary preserved, replaced, or retired
  when applicable;
- acceptance/verification evidence;
- handoff; and
- fixture scenario and backend-replacement package ID, when relevant.

## Milestone contract

Every phase is a milestone: a reviewable point of progress toward the target
end product. A milestone must have:

- a named outcome that is observable at product or implementation level;
- a traceable contribution to the target end product, including the capability,
  trusted state, or delivery constraint it unlocks and what remains unavailable
  without it;
- entry conditions and predecessor dependencies;
- bounded implementation and sequencing boundaries;
- a bounded implementation scope;
- research or decisions required to proceed;
- acceptance evidence and any source-documented decision gate;
- an exit gate that determines whether the milestone is achieved, revisited,
  or deferred; and
- a handoff to the next milestone or later operational work.

Activities finishing is not sufficient evidence of milestone completion. The
milestone must produce the stated outcome or explicitly record why the gate
failed and what happens next.

## Target end-product baseline

Before phase design, derive a concise product baseline from both source
contexts. It should answer:

- what product, service, capability, or experience will exist at the end;
- who uses it or receives value from it;
- which primary capabilities and workflows must work;
- what is inside the system boundary and what remains external;
- which quality, security, privacy, performance, reliability, or operational
  expectations materially shape implementation; and
- how the result will be recognized as complete at product level.

Keep the baseline separate from the implementation plan. Project Context owns
the intended outcome and scope; Stack Context explains the technology
capabilities and constraints; Implementation Context reconciles them into a
feasible target product without silently changing either source. Record the
claim state and evidence for each material part. If Project Context and Stack
Context imply different end products, mark the context `needs-review` or
`blocked` until the conflict is resolved.

## Claim states

Use claim states instead of flattening all information into a single voice:

- `user-intent` - explicitly supplied target, priority, or decision;
- `observed` - directly verified in the repository or environment;
- `documented` - supported by inspected Project Context, Stack Context, or
  authoritative documentation;
- `inferred` - a reasonable interpretation that still needs confirmation;
- `unknown` - material information is unavailable; and
- `conflicted` - credible sources disagree.

Keep claim state separate from decision status. A user-selected design can be
`user-intent` even when its performance or compatibility evidence is still
`unknown`.

## Decision and research statuses

Use status values consistently:

- `confirmed` - approved and safe to use as an implementation constraint;
- `proposed` - recommended but awaiting user or authority confirmation;
- `experimental` - bounded evaluation is allowed but it is not a baseline;
- `deferred` - intentionally postponed without blocking the current phase;
- `blocked` - cannot proceed safely until the missing answer or dependency is
  resolved; and
- `superseded` - replaced by a later decision, with the replacement linked.

Milestone statuses may be:

- `planned` - defined but not started;
- `in-progress` - work is underway;
- `achieved` - the acceptance gate passed with evidence;
- `blocked` - a dependency or decision prevents safe progress; and
- `revisiting` - the gate failed or new evidence requires the milestone to be
  reshaped.

For research:

- `planned` - question is identified but not investigated;
- `in-progress` - evidence gathering is underway;
- `answered` - evidence is sufficient for the current decision; and
- `inconclusive` - evidence was gathered but does not resolve the question.

## Readiness states

- `draft` - the implementation model is not coherent enough to review;
- `needs-review` - useful milestone phases exist, but a material decision, dependency,
  authority, or evidence gap can change the plan;
- `ready` - project traceability, milestone phases, decisions, research, verification,
  and handoffs are clear enough for the next execution-aware action; and
- `stale` - a material Project Context, Stack Context, repository, or external
  constraint change invalidates the recorded implementation model.

## Minimum readiness test

The Implementation Context is sufficient when:

- the target end product is explicitly reviewed from both Project Context and
  Stack Context, with capabilities, boundaries, quality expectations, and
  acceptance signals visible;
- each material Project Context outcome has a phase, explicit deferral, or
  documented reason it is out of scope;
- each milestone states the reviewed end-product capability, trusted state, or
  delivery constraint it advances, rather than only a technical activity;
- project state is classified from repository evidence and, for existing-code
  or hybrid work, material current-state preservation/replacement boundaries
  are visible before dependent change is sequenced;
- each phase is a milestone with a clear outcome, entry conditions, outputs,
  dependencies, verification evidence, source-documented decision gates, and
  an exit gate;
- implementation decisions are distinguishable from proposals and tasks;
- inherited stack constraints and unknown stack decisions are visible;
- the Architecture Overview and Decision Register make material
  implementation-shape choices and their effects on later work visible;
- research findings support the decisions that need current or external
  evidence;
- source-documented decision gates and unresolved decisions are visible enough
  to prevent silent assumptions;
- integration, data, security, quality, operational, and transition concerns
  are addressed when relevant; and
- no unresolved question or dependency blocks the next context-aware action.

The number of phases, pages, or research links is not a readiness measure.

## Ticket-generation readiness test

Apply this test to every Implementation Context. A context can be `ready` for
milestone-based implementation planning while its work-package map is not yet
ready to generate tickets.

The work-package map is ticket-generation ready when:

- every in-scope milestone has candidate work packages at the user-approved
  granularity, or an explicit reason it is not decomposed;
- every package has a stable ID, bounded outcome, scope and exclusions,
  dependency IDs, affected interfaces, verification evidence, and handoff;
- every existing-code or hybrid package that changes a material live seam
  identifies the behavior/data/runtime boundary it preserves, replaces, or
  retires;
- the dependency graph distinguishes sequential prerequisites from parallel
  work and reconciles with the package dependency records;
- the project outcome -> milestone -> package -> evidence trace is complete;
- fixture-first scenarios and their backend-adapter replacement points are
  linked with their preserved invariant or marked not applicable; and
- no unknown interface, dependency, acceptance criterion, or authority would
  make a generated ticket misleading or unreviewable; and
- no unresolved or stale architecture decision changes the selected package’s
  boundaries, dependencies, interface, or verification.

If any condition fails, report `not-ready` with the missing planning input;
do not disguise the gap by emitting speculative tickets.
