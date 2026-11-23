---
name: engineering-security-refactor-readiness
description: Assess planned implementation work against a scoped OWASP and NIST security-readiness baseline, identifying controls to implement now, hardening seams to preserve, prohibited couplings, and review bindings. Use during ticket authoring before implementation; do not use as a full compliance audit.
---

# Engineering Security Refactor Readiness

## Outcome

Given a bounded ticket scope plus accepted project and architecture context,
apply the relevant parts of the OWASP and NIST baseline to identify controls
that belong in the ticket now and seams that must remain available so later
security hardening can be added without avoidable architectural redesign.

This skill is implementation-planning guidance only.

It does not declare an implementation secure, perform a full compliance audit,
select organizational risk tolerance, or grant review approval.

## Security baseline

Read [the security baseline reference](references/security-baseline.md) before
assessing a work unit. Use it as a decision lens, not an unbounded checklist:

- OWASP ASVS supplies application-control and verification topics;
- OWASP Top 10 supplies a current web-application risk lens;
- NIST CSF 2.0 supplies lifecycle and risk-outcome framing; and
- NIST SP 800-53 supplies control-family and assessment vocabulary.

Evaluate only topics materially touched by the bounded scope. Record the
applicable framework references and the rationale for each material decision.
Framework guidance identifies candidate controls; it becomes a ticket
requirement only when accepted project, architecture, policy, regulatory, or
ticket authority adopts it. Do not turn an arbitrary framework control into
work merely because it exists.

## Required reasoning

For the supplied work unit, identify only what is supported by the supplied context:

- security-relevant trust transitions;
- sensitive assets and authority;
- existing accepted boundaries inherited by the ticket;
- identity or execution context that should remain available;
- extension seams where later security policy can attach;
- implementation couplings that would make later hardening invasive;
- observability, configuration, persistence, error-handling, and verification seams when materially relevant;
- security policy that remains intentionally unresolved;
- mandatory review bindings for material readiness expectations.

For every material baseline topic, classify it as exactly one of:

- `implement-now` - accepted authority and the current scope require a control
  and its verification now;
- `preserve-seam` - current scope does not authorize the control, but must
  retain an implementation-neutral attachment point for it;
- `deferred-policy` - a policy, risk-tolerance, provider, or architecture
  decision is needed before the control can be selected; or
- `not-applicable` - the bounded scope does not materially touch the topic.

`implement-now` items must become ticket-scoped requirements and review
bindings. `preserve-seam` items become invariants, exclusions, or boundary
requirements. `deferred-policy` items remain explicit planning findings; they
must not be implemented from framework inference alone.

## Boundary preservation

Accepted project or dependency boundaries are authoritative input.

Do not silently:

- replace an accepted technology;
- collapse an accepted authority boundary;
- reopen an approved predecessor;
- invent a security policy;
- introduce a new provider or infrastructure dependency;
- turn an unresolved security question into an implementation assumption.

If the proposed work cannot preserve an accepted boundary, emit a planning finding.

## Scope discipline

Reason only from the supplied ticket scope and bounded project context.

Do not scan the entire project, security standards collection, historical ticket corpus, or unrelated implementation unless explicitly asked to perform planning discovery.

This skill is not the future full security-baseline assessment.

## Output

Return a compact `SecurityReadiness` result containing, as applicable:

- `status`
- `inheritedBoundaries`
- `trustBoundaries`
- `sensitiveAssets`
- `identityContext`
- `extensionSeams`
- `prohibitedCouplings`
- `verificationSeams`
- `unresolvedSecurityPolicy`
- `planningFindings`
- `reviewBindings`
- `baselineAssessment`

Use stable IDs for every material seam, coupling, finding, and review binding.

Every review binding must reference the readiness item it verifies.

Each material `baselineAssessment` item must contain a stable ID, framework
reference, affected scope/boundary, disposition, authority trace, rationale,
and required evidence when its disposition is `implement-now`.

## Status

Use:

- `applicable`
- `minimal-relevance`
- `planning-review-required`

`planning-review-required` blocks ticket finalization until the relevant planning conflict is resolved.

## Review bindings

Review bindings are mandatory minimum coverage for implementation review.

They are not the maximum scope of independent review.

A review binding should contain:

- stable review ID;
- readiness item reference;
- narrow review question;
- expected evidence category.

## Future baseline compatibility

Where possible, describe extension points in implementation-neutral terms.

A later security-baseline system may attach canonical controls and verification requirements to these same readiness IDs.

Do not invent those future controls now.

## Final rule

Preserve tomorrow's security-policy attachment points while implementing today's accepted scope.
