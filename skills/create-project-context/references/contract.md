# Project Context contract

This contract defines the semantic boundary and readiness test for the Project
Context artifact. It is a guide for reasoning, not a mandatory document outline.
Combine or omit lenses when that makes the project easier to understand.

## What Project Context owns

Project Context is the durable project-level model of:

- what the project is and why it exists;
- the problem, opportunity, value, objectives, and intended outcomes;
- high-level deliverables, scope, non-goals, and affected areas;
- users, stakeholders, ownership, governance, and decision authority;
- domain, operating environment, system boundaries, and external obligations;
- current state, target state, compatibility promises, and transition posture;
- assumptions, constraints, invariants, dependencies, and project-level risks;
- observable success and acceptance basis; and
- evidence, unresolved questions, deferred decisions, and material drift.

It may mention a system, integration, or technology when that fact changes the
project boundary, is an explicit user decision, or is part of current state
whose compatibility matters. It must not become a technology catalog,
architecture design, implementation plan, backlog, or ticket set.

## Semantic lenses

Use only the lenses that matter to the project, while ensuring the final model
answers the essential project questions:

1. **Project frame** - problem/opportunity, rationale, value, and target outcome.
2. **Objectives and outcomes** - what must change and how the project knows it
   has achieved the intended result.
3. **Scope and non-goals** - what the project covers, excludes, and affects.
4. **People and governance** - users, stakeholders, sponsor, owner, decision
   authority, and responsibility boundaries.
5. **Domain and boundaries** - operating context, owned areas, external
   dependencies, obligations, and contracts.
6. **Current and target state** - baseline, intended result, compatibility,
   rollout posture, and removal or transition gates when relevant.
7. **Constraints and assumptions** - limits and invariants later work may not
   silently violate.
8. **Success and acceptance basis** - observable project-level signals and
   acceptance boundaries.
9. **Risks, dependencies, and decisions** - keep confirmed decisions separate
   from risks and from intentionally deferred choices.
10. **Evidence and drift** - sources, claim states, baseline, and watchlist.

For Project Context ownership, distinguish `author` or `maintainer`,
`contributors`, `approver`, and `accountable decision owner` when evidence
supports the distinction. Use role titles rather than names when appropriate.
Use `to-confirm` when a role is material but unknown. Do not infer ownership
from commit history or document authorship alone.

## Claim states

Use claim states instead of flattening all information into a single voice:

- `user-intent` - explicitly supplied target or decision;
- `observed` - directly verified current repository state;
- `documented` - supported by inspected project material;
- `inferred` - reasonable interpretation that still needs confirmation;
- `unknown` - material information is unavailable; and
- `conflicted` - credible sources disagree.

For consequential claims, record a compact evidence marker or evidence ID.
Never cite a source that was not inspected. Preserve current state, target
intent, and conflicts separately.

## Readiness states

- `draft` - the project model is not yet coherent enough to review.
- `needs-review` - useful content exists, but a material question, conflict,
  missing authority, or missing boundary blocks confidence.
- `ready` - the project is defined, bounded, governed, and evaluable; remaining
  unknowns are explicitly classified as non-blocking or deferred.
- `stale` - a material change has invalidated the recorded project model.

Do not require every technical or operational detail for `ready`. Do require
enough clarity that another person can understand what the project is trying to
change, what is inside or outside its boundary, who can decide, and how success
will be judged.

## Minimum readiness test

The Project Context is sufficient when all of these are true:

- the project identity and rationale are understandable;
- objectives and intended outcomes are explicit enough to evaluate;
- scope and non-goals are distinguishable;
- ownership and decision authority are known or marked `to-confirm`;
- material constraints, dependencies, and boundaries are visible;
- current and target state are not being confused;
- success or acceptance basis exists at project level; and
- no unresolved project-level question blocks continuation.

The number of pages, completed headings, or technical decisions is not a
readiness measure.
