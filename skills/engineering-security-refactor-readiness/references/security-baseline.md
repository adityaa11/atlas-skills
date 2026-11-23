# Security baseline reference

Use this reference only for the bounded work unit under assessment. It is a
planning lens; the accepted ticket and its incorporated authority still decide
what must be implemented and verified.

## Source set

- **OWASP ASVS 5.0.0** - primary application-security control and verification
  reference. Use relevant requirement identifiers when the work changes
  authentication, authorization, session handling, input or output handling,
  cryptography, data protection, communication, configuration, logging,
  business logic, API, file, or browser-facing behavior.
- **OWASP Top 10: 2025** - risk-awareness lens. Use it to identify plausible
  application risks, not as a complete implementation checklist.
- **NIST CSF 2.0** - outcome lens: Govern, Identify, Protect, Detect, Respond,
  and Recover. Use it to expose omitted lifecycle outcomes such as ownership,
  inventory, protection, logging, incident handling, or recovery readiness.
- **NIST SP 800-53 Release 5.2.0** - control-family and assessment vocabulary.
  Use only the control families material to the work, such as AC, IA, AU, CM,
  CP, RA, SA, SC, SI, PT, or SR. Do not claim a complete 800-53 baseline or
  compliance assessment.

Prefer the official current publication when a version changes. Record the
version used in the assessment so a ticket remains reproducible.

## Scoped routing

Apply only the baseline topics implicated by the work:

| Work touches | Evaluate at minimum |
| --- | --- |
| Identity, access, roles, tenancy, privileged actions | ASVS authentication/authorization; OWASP access-control risks; NIST CSF Protect; NIST AC/IA/AU families. |
| API, service boundary, web endpoint, message or external input | ASVS input/API/communication topics; OWASP injection and security-misconfiguration risks; NIST SC/SI families. |
| Secrets, PII, tokens, credentials, confidential payloads | ASVS data protection/cryptography/logging; OWASP cryptographic and logging risks; NIST SC/SI/PT families. |
| Browser UI, dynamic content, third-party scripts, file/PDF rendering | ASVS browser/API/input/output topics; OWASP injection and supply-chain risks; NIST SC/SI/SR families. Also invoke `frontend-awareness` when the work changes UI. |
| Persistence, queues, jobs, retries, workflows, audit records | ASVS business logic/configuration/logging; OWASP integrity and logging risks; NIST AU/CM/CP/SI families. |
| Dependency, provider, build, release, configuration, deployment boundary | OWASP security-misconfiguration and supply-chain risks; NIST CSF Govern/Identify/Protect; NIST CM/SA/SR/SI families. |

If no row applies, record `minimal-relevance` with the specific reason rather
than fabricating a security concern.

## Disposition test

For each material topic:

1. Trace the behavior to accepted ticket, project, architecture, policy,
   regulatory, or explicitly incorporated source authority.
2. If that authority requires the control in this bounded work, mark it
   `implement-now` and define ticket-scoped proof.
3. If the authority defers the control but the current design can avoid making
   it invasive later, mark it `preserve-seam` and state the boundary to keep.
4. If selecting a control requires a policy, risk tolerance, provider,
   runtime, deployment, or architecture decision not yet accepted, mark it
   `deferred-policy` and raise a planning finding.
5. Otherwise mark it `not-applicable` with a scope-bound reason.

Never use framework guidance to replace an accepted technology, choose a
security provider, add infrastructure, or silently expand the ticket.

## Evidence discipline

For an `implement-now` item, name the smallest evidence capable of proving the
control at the relevant boundary: an adversarial test, integration test,
configuration assertion, static dependency/call-graph check, audit/logging
assertion, or operational evidence. A generic suite pass is not evidence when
the scope names a particular boundary or observation.

For a `preserve-seam` item, verify the stated seam or prohibited coupling; do
not require the deferred control itself.

## Official sources

- OWASP ASVS: https://asvs.owasp.org/
- OWASP Top 10: https://owasp.org/projects/Top-Ten
- NIST CSF 2.0: https://www.nist.gov/cyberframework
- NIST SP 800-53: https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final
