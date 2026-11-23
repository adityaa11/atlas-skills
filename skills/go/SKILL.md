---
name: go
description: Atlas implementation-phase GO workflow control. Use only when the user invokes `go` as the Atlas ticket workflow command or explicitly authorizes GO for a bounded Atlas ticket. Do not use for Go language/code requests or ordinary uses of the word "go".
---

# Atlas GO Workflow

GO authorizes implementation of the current frozen ticket or explicitly authorized batch. The ticket is the executable contract; GO does not create requirements, approve work, or reopen accepted scope.

## Shared interpretation rule

GO, CK, CFC, and HMN MUST derive active-ticket scope, acceptance obligations,
validation obligations, evidence sufficiency, and finding closure from the
[shared Atlas Review Contract](../_shared/atlas-ticket-review-contract.md).
GO MUST NOT substitute its own broader or narrower interpretation.

## Artifact store rule

Before resolving a ticket or writing a checkpoint, resolve and validate the
artifact store using the [shared Atlas Artifact Store Contract](../_shared/atlas-artifact-store-contract.md).
Read tickets from `.atlas/tickets/` and write implementation checkpoints under
`.atlas/checkpoints/`. Do not use an implied project folder, `.agents`, or the
skills repository. Commit authorized implementation source and test paths in
the code repository. Bind each durable checkpoint to that exact code
commit, then commit the checkpoint record separately in the artifact
repository. Never copy source code into the artifact repository.

## Before implementation

1. Resolve the authorized ticket or batch from the user's instruction and the relevant ticket-set README. Do not choose a new ticket unless the user authorized that progression.
2. Read the frozen ticket and the source references it explicitly incorporates. Read only the accepted dependency material needed to understand interfaces and boundaries this ticket consumes.
3. Confirm required predecessors are approved/PASS for their final checkpoints, the current checkpoint is eligible to start, and the implementation target is clear. An `awaiting_review` predecessor is not approved.
4. Treat dependencies as accepted interfaces, capabilities, invariants, and authority boundaries used by this ticket. Do not inherit their deferred work, recommendations, future providers, deployment plans, or unrelated requirements.
5. Derive the full Review Contract before coding: every implementation,
   validation, and evidence row; required harnesses, scenarios, and observations;
   behavior-versus-proof distinctions; and forbidden scope expansion. GO MUST NOT
   start from only a ticket title or Outcome section.

For each row, record the ticket's pass condition separately from the evidence
that will demonstrate it. Do not turn every available diagnostic surface into
an acceptance condition. This row ledger is the basis for GO readiness and
the checkpoint CK will review; later CK or HMN wording cannot add ticket
obligations.

Before collecting ticket evidence, inspect relevant previously committed
artifacts and classify each required observation as new proof or a candidate
immutable reference under the shared Review Contract. Reuse a valid unchanged
baseline by reference when permitted; collect fresh current-state proof for
changed surfaces and every ticket-mandated recapture. This inventory is an
evidence plan within existing rows, not an added acceptance gate.

If a required predecessor must be reopened, or the work needs a new product requirement, provider, runtime, deployment target, architecture decision, or unresolved policy, stop and return that decision to human/planning authority. Repository code, tests, runtime entrypoints, specialist guidance, and deployment configuration are implementation evidence; they do not add ticket scope.

## Implement and hand off

Implement only the authorized ticket. Preserve unrelated user changes and approved predecessor boundaries. Run the validation required by the ticket and regressions directly affected by the implementation. Record the bounded changes, commit, exact validation evidence, and applicable limitations in the ticket/checkpoint record. Commit only authorized paths and set the ticket to `awaiting_review` using its existing vocabulary.

Treat each ticket-named validation scenario as completion work and use the
contract-required harness and observations; a weaker test or generic suite pass
is not a substitute. Before commit/handoff, perform a shadow-CK readiness check for every
applicable contract row, comparing required and actual evidence and assigning
the shared closure status. GO MUST NOT hand off with a known `UNRESOLVED`,
`IMPLEMENTED_UNPROVEN`, `BLOCKED_AUTHORITY`, or `BLOCKED_ENVIRONMENT` row unless
the frozen ticket explicitly permits skipping that validation and defines
accepted alternative proof. Do not use CK as a requirements-discovery phase.

The checkpoint MUST include a compact `## Review Contract Closure` summary with
stable row IDs, ticket authority, required proof, evidence/test locator, exact
validation command and outcome, and status, followed by `Internal readiness:
READY_FOR_CK`. CK should be able to decide each row from this ledger and the
committed evidence without inventing missing acceptance conditions. This is
never a self-issued `PASS`.

For a reused evidence item, put the artifact commit, path, blob SHA, original
code commit, observation context, and current-commit applicability reason in
the applicable row's evidence locator. Record new observations and executed
validation separately. Do not copy an old binary into a new checkpoint folder
merely to give it a new path; do not claim that a reused image proves behavior
at the current commit without the required current validation and change
analysis.

If an existing harness always writes both reusable baselines and current
captures, run it into an isolated temporary output directory when the ticket
permits reference reuse. Promote only required new observations to the artifact
repository and cite prior committed baselines in the checkpoint. The required
harness still runs, and its command/outcome remain recorded. For new or
ticket-authorized harness changes, make baseline and current capture selectable
so an unchanged baseline need not be generated on every run. Do not modify a
frozen harness requirement solely to avoid evidence work, and never discard a
capture the ticket requires to be committed independently.

For every applicable ticket-defined expected use path, include `## Actual Use
Path`: the committed caller, entrypoint, function/component chain, endpoint,
consumer/effect, code locations, executed integration evidence, and any
mismatch from the frozen expectation. A production function reached only from
unit tests is not ready for CK unless the ticket explicitly defines it as a
test-only artifact.

When a ticket defines a true code path, include the actual retirement/removal
or unreachability evidence for each superseded path. Do not retain a fallback,
compatibility wrapper, duplicate branch, or old production caller merely to
protect previously approved code, unless the frozen ticket explicitly permits
the named legacy path and its retirement terms.

For persistence work, include `## Migration Inventory`: every intended
migration/production-data change, its ticket authority and operational
consumer, plus the ephemeral test setup and teardown mechanism. Do not commit
test-only seed SQL, migration files, or migration-runner conditionals; use the
ticket-defined ephemeral test mechanism instead.

For every ticket-defined empty/initial-state contract, include `## Actual
Empty-State Evidence`: the clean database/tenant/query condition, actual
entrypoint and endpoint result, initialization/idempotency outcome, and first
handoff where applicable. Do not add a hidden default or durable seed merely
to make first-use validation pass.

Then stop and return control to CK. GO does not review or label its own work `PASS`, remediate CK findings, or perform unrelated cleanup.

When invoked after a CK `PASS`, record the approved state. Begin another dependency-ready ticket only if the user's GO authorization covers that ticket or batch. A `CHANGES_REQUIRED` result belongs to CFC and must not be remediated by GO under the same frozen contract. The shared Review Contract's planning-amendment path is distinct: after an explicit change to the effective ticket and user authorization for revised implementation, GO may submit a new checkpoint for first full CK review. Record the amendment ID, changed and retained rows, historical CK reference, and current code commit; do not claim the old finding was CFC-closed or erase its result.

If a current HMN artifact explicitly records `RETURN_TO_GO`, GO may resume or complete only the frozen-ticket implementation named by that authorization and must record its HMN authorization ID in the checkpoint. GO must not consume `AUTHORIZE_NEXT_CFC`, `AUTHORIZE_EVIDENCE_REMEDIATION`, or `AUTHORIZE_DIRECT_REGRESSION_REPAIR`; those belong to CFC. An HMN artifact never expands ticket scope.

## Authority

```text
frozen current ticket
> its explicit source references
> the published dependency interfaces/boundaries it consumes
> repository evidence for implementation
> general engineering or specialist guidance
```

The ticket decides the work. GO implements that work and leaves it `awaiting_review`.
