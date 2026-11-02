# Stack Context contract

This contract defines the semantic boundary and readiness test for a Stack
Context. It is a decision aid, not a mandatory heading layout.

## What Stack Context owns

Stack Context is the project-level record of which technologies are selected
for later implementation and why. It translates project needs into stack
decisions without expanding into implementation design.

It may define:

- stack layers or capability groups;
- selected technologies and their intended conceptual roles;
- experimental candidates and their evaluation purpose;
- deferred and excluded options;
- rationale, alternatives, trade-offs, and decision risks;
- compatibility and non-functional considerations;
- a bounded implementation simulation; and
- unresolved decisions that Implementation Context must revisit.

It must not define:

- source-code structure or package boundaries;
- concrete APIs, database schemas, deployment topology, or infrastructure
  manifests;
- exact implementation tasks or delivery sequencing;
- detailed configuration or version pinning without explicit evidence; or
- requirements that are not grounded in the Project Context.

## Decision record

Each meaningful choice should be understandable through this mapping:

```text
Project need
  -> candidate options
  -> selected status
  -> conceptual role
  -> rationale and evidence
  -> implementation simulation
  -> trade-offs and residual uncertainty
```

Use a compact evidence marker for consequential claims. Never cite a source
that was not inspected. A technology may be selected while a version or
specific implementation pattern remains deferred.

## Selection statuses

- `selected` - chosen as the current project baseline for later implementation.
- `experimental` - allowed for bounded evaluation, not a baseline dependency.
- `deferred` - relevant option or decision intentionally postponed.
- `excluded` - not allowed for the current baseline, with a reason when the
  exclusion is material.

## Claim states

- `user-intent` - explicitly requested or decided by the user;
- `observed` - verified in the repository or environment;
- `documented` - supported by inspected project material or authoritative
  documentation;
- `inferred` - a reasonable interpretation that still needs confirmation;
- `unknown` - material information is unavailable; and
- `conflicted` - credible sources disagree.

Keep claim state separate from selection status. For example, a technology can
be `selected` by explicit user intent while its performance claim remains
`unknown`.

## Readiness states

- `draft` - candidate choices are not coherent enough to review;
- `needs-review` - useful choices exist, but a material constraint, conflict,
  or authority question can change the selection;
- `ready` - the stack is selected at the intended level, rationale and
  trade-offs are visible, and remaining unknowns are non-blocking or clearly
  deferred; and
- `stale` - a material change in Project Context or project constraints
  invalidates the recorded stack.

Do not require final package versions, implementation details, or complete
architecture before marking Stack Context `ready`. Do require enough clarity
that an implementation team can understand what technologies are allowed,
why they were chosen, and what must still be decided later.

## Minimum readiness test

The Stack Context is sufficient when:

- every selected technology maps to a Project Context need;
- important capability gaps have a status rather than being silently ignored;
- selected and experimental technologies are distinguishable;
- the simulation explains the expected future use without becoming a plan;
- material trade-offs and alternatives are visible;
- compatibility, licensing, support, or operational risks are recorded when
  relevant; and
- no unresolved stack-level question blocks the next context-aware action.

