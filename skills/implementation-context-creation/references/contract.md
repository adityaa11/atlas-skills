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
- traceability from Project Context outcomes and boundaries;
- inherited Stack Context decisions and implementation consequences;
- milestone-based phase objectives, dependencies, entry/exit criteria, and
  handoffs;
- capability or workstream boundaries;
- conceptual component, interface, data, integration, and transition
  decisions;
- research questions, evidence, findings, confidence, and decision impact;
- verification, observability, security, privacy, and operational readiness
  expectations;
- roles, approval boundaries, and responsibility by phase;
- risks, assumptions, decision triggers, reversibility, and change control; and
- open questions and the next execution-planning handoff.

It must not become:

- a replacement for Project Context or Stack Context;
- a full software design specification when the project is not ready for that
  detail;
- an unapproved backlog, sprint plan, estimate, or individual assignment list;
- a record of research detached from decisions; or
- a collection of implementation claims without evidence or uncertainty.

## Traceability model

Every material phase or decision should be understandable through this chain:

```text
Target end product
  -> project outcome or constraint
  -> implementation objective
  -> milestone phase / workstream
  -> technical or product decision
  -> verification evidence
  -> exit condition and next handoff
```

If a milestone phase cannot be traced to a project outcome, scope item,
constraint, dependency, or risk, mark it as proposed and ask whether it
belongs. If a project outcome has no milestone phase or explicit reason for
deferral, mark the gap.

## Milestone contract

Every phase is a milestone: a reviewable point of progress toward the target
end product. A milestone must have:

- a named outcome that is observable at product or implementation level;
- a traceable contribution to the target end product;
- entry conditions and predecessor dependencies;
- workstreams and role responsibilities;
- a bounded implementation scope;
- research or decisions required to proceed;
- acceptance evidence and a named reviewer or approval role;
- an exit gate that determines whether the milestone is achieved, revisited,
  or deferred; and
- a handoff to the next milestone or to operational ownership.

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
- each phase is a milestone with a clear outcome, entry conditions, outputs,
  dependencies, verification evidence, acceptance reviewer, and exit gate;
- implementation decisions are distinguishable from proposals and tasks;
- inherited stack constraints and unknown stack decisions are visible;
- research findings support the decisions that need current or external
  evidence;
- role and approval boundaries are clear enough to prevent silent ownership;
- integration, data, security, quality, operational, and transition concerns
  are addressed when relevant; and
- no unresolved question or dependency blocks the next context-aware action.

The number of phases, pages, or research links is not a readiness measure.
