# Architecture overview and decision lifecycle

Use this reference to create a decision-oriented system overview that is
detailed enough to guide milestones and ticket generation without becoming a
ticket-level design specification.

## Architecture Overview

Derive the overview from the end product, selected stack, and repository
evidence. Include only material choices that shape more than one work package
or constrain a later milestone:

- delivery, application, package, module, or deployment boundaries;
- authoritative data, identity, trust, and ownership boundaries;
- major interface, adapter, integration, and compatibility seams;
- fixture, test-double, contract, or backend-replacement strategy;
- material migration, transition, rollout, and rollback posture; and
- cross-cutting quality constraints such as security, privacy, reliability, or
  observability when they change the implementation shape.

Do not write exact file trees, database columns, endpoint payloads, internal
algorithms, or class designs. Those are ticket-level design unless they are
already an accepted source constraint.

## Decision Register

Give every material decision a stable ID. Record:

```text
Decision ID:
Question:
Status: confirmed | proposed | deferred | blocked | superseded
Evidence and rationale:
Affected end-product capability / milestone / package:
Affected interfaces and verification:
Enables or blocks:
Revisit trigger:
```

Use `proposed` for a bounded recommendation that needs a user answer. Use
`deferred` only when the next milestone can safely proceed without the choice.
Use `blocked` when it cannot. A `superseded` decision links to its replacement;
do not rewrite history.

## Initial and later elaboration

Initial context creation must resolve or surface the decisions needed for the
next executable milestone and its dependent work packages. It should also make
the longer-term architectural direction visible, while leaving ticket-local
details for later ticket-set creation.

Ticket-set creation may elaborate the selected package’s implementation design.
When that work resolves, changes, or invalidates a registered architecture
decision, it must supply a decision update to Implementation Context before
dependent later tickets are generated. The refresh updates the decision status,
Architecture Overview, package graph, affected interfaces, verification, and
milestone readiness.

If the decision affects only the current ticket’s local implementation and not
an interface, later package, or milestone, keep it in the ticket rather than
expanding the Implementation Context.
