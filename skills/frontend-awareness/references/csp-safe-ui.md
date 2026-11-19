# CSP-safe UI

Use this reference when frontend work can affect browser code execution,
dynamic markup, runtime styles, loaded resources, or browser security-policy
behavior.

## Purpose and boundary

Content Security Policy (CSP) is a browser-enforced defense in depth against
XSS and unapproved resource loading. It does not replace safe rendering,
context-appropriate output handling, authorization, or input validation.

The deployed CSP header and its delivery mechanism are project-owned security
boundaries. Do not set CSP headers in components, route modules, or client
code. Do not add `unsafe-inline`, `unsafe-eval`, broad origins, or a local
exception as a compatibility shortcut.

An application cannot create an equivalent CSP boundary after page code begins
to run. Header delivery, request-scoped nonces, enforcement, report-only
rollout, and violation reporting require a server, edge, or deployment owner.
This reference distinguishes work that UI code can do now from seams it must
preserve for those owners.

## Development tool compatibility

Some development tools, including browser annotation or inspection modes, may
inject scripts or styles that a strict CSP correctly blocks. When that prevents
necessary development work, provide an explicit CSP mode switch at the
server, edge, or local-runtime boundary. Do not expose this as an application
UI setting and do not let client code decide the active policy.

Use a named configuration value rather than a boolean when possible:

| Mode | Intended use | Header behavior |
| --- | --- | --- |
| `enforce` | Default and every production-like validation run | Send `Content-Security-Policy`. |
| `report-only` | Investigating a planned policy change | Send `Content-Security-Policy-Report-Only`; do not describe this as protection. |
| `disabled` | Local development only, for tools that cannot operate under CSP | Send neither CSP header. |

The `disabled` mode is an intentional compatibility escape hatch, not an
alternative deployment posture. Its contract must be narrow:

- default to `enforce` when configuration is missing, malformed, or unknown;
- allow `disabled` only in an explicitly recognized local-development
  environment;
- fail startup or deployment validation if `disabled` is selected for preview,
  staging, production, CI security checks, or any internet-reachable runtime;
- keep the switch outside source-controlled user preferences and never toggle
  it from a query parameter, cookie, browser storage, or normal application
  control;
- make the mode visible in local runtime logs or a developer-only diagnostic,
  without adding an end-user control; and
- remove or disable any CSP-violating development extension before an
  enforcement validation run.

Use this workflow: select `disabled` only while the blocked development tool is
needed, return to `enforce` before recording results or requesting review, and
run the CSP regression and browser checks under `enforce`. Use `report-only`
only to diagnose a candidate policy change; it is not evidence that enforced
CSP works.

## Immediate UI discipline

Apply these controls without waiting for a server change:

- Use the framework's ordinary rendering and escaping behavior for text.
- Treat data from users, URLs, storage, APIs, documents, and other services as
  untrusted until its rendering context is understood.
- Build dynamic DOM with framework components or safe DOM APIs such as
  `createElement` and `textContent`. Keep element and attribute names fixed.
- Validate complete URLs against the product's allowed schemes and origins
  before assigning `href`, `src`, iframe, worker, navigation, or fetch values.
  Encoding a URL parameter does not validate a complete URL.
- Use React or framework event props with trusted handler functions. Do not use
  HTML event-handler attributes or construct executable handler strings.
- Put presentation in project stylesheets, classes, tokens, and approved
  component APIs. Do not depend on inline `style` attributes, CSS-string
  interpolation from untrusted data, or imperative `.style.*` mutation.
- Keep third-party scripts, fonts, embeds, analytics, remote images, workers,
  and API origins explicit and centralized. A component must not silently add
  an external origin.
- Treat `eval`, `Function`, string-based `setTimeout`/`setInterval`, and
  equivalent string compilation as prohibited.

Do not introduce these patterns without an explicitly scoped security design:

- `dangerouslySetInnerHTML`, `innerHTML`, `outerHTML`, `insertAdjacentHTML`,
  `document.write`, or similar HTML-parsing sinks;
- inline `<script>` or `<style>` blocks;
- inline HTML event attributes such as `onclick`; or
- untrusted data in HTML, JavaScript, CSS, URL, or attribute contexts whose
  interpretation is not explicitly controlled.

When rendering user-authored HTML is an approved product requirement, use one
maintained allowlist sanitizer through a reviewed shared adapter. Preserve the
sanitizer's output unchanged, validate URL-bearing attributes separately, and
do not pass untrusted script or style content through that adapter. Never add
a permissive default Trusted Types policy merely to suppress errors.

## Project CSP discovery

Before a CSP-relevant change, inspect the existing policy and its tests. Record
which project-owned directives or runtime constraints apply, including as
needed:

- permitted script, style, image, font, connection, worker, frame, and media
  sources;
- nonce or hash propagation and whether framework output is already covered;
- restrictions on inline styles and event handlers;
- dynamic imports, WebAssembly, canvas/PDF viewers, and worker creation;
- supported browser range; and
- report-only versus enforcement behavior.

Do not infer that a currently working browser behavior is permitted by the
policy. A new external origin, execution primitive, or rendered markup shape
requires an explicit project-policy decision.

## Preserve server and deployment seams

Keep these attachment points available; do not implement their authority in
the client:

| Future control | UI seam to preserve now |
| --- | --- |
| Nonce or hash-based strict CSP | Avoid app-owned inline executable content. Let the framework and server/edge own nonce or hash propagation. |
| CSP mode switching, report-only rollout, and reporting | Keep targeted browser-console and rendered-response checks runnable; do not hide or ignore violations. Keep runtime-mode selection at the server, edge, or local-runtime boundary. |
| Trusted Types enforcement | Route approved HTML rendering through one audited adapter and avoid arbitrary HTML sinks. |
| Third-party source approval | Centralize external resource declarations and record their exact purpose, origin, and affected directive. |
| Subresource integrity or build-time hashes | Keep static third-party resource declarations discoverable rather than generating opaque tags at runtime. |
| Policy extension or tightening | Keep policy construction and headers centralized outside UI components; add a focused regression for any approved change. |

Trusted Types can provide browser-level protection for certain DOM injection
sinks, but enforcement requires CSP directives delivered by the response.
Preparing the UI means minimizing sinks now, not adding a client-only shim and
claiming equivalent enforcement.

## Verification

For a CSP-relevant UI change, use proportionate evidence:

1. Search changed and directly related code for new unsafe sinks, inline
   handlers, inline script/style blocks, string compilation, runtime style
   writes, and unreviewed external origins.
2. Run the project's CSP or rendered-response regression tests.
3. Render the affected routes and interactions. Inspect browser console and
   network behavior for CSP violations in the relevant themes, viewport modes,
   error states, and client-navigation paths.
4. If a new policy capability is genuinely required, stop at a documented
   request for the server/deployment owner. State the exact directive, origin
   or primitive, necessity, alternatives considered, and test coverage. Do not
   self-author a weaker policy.

## Sources

- OWASP, [Content Security Policy Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
- OWASP, [Cross Site Scripting Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- OWASP, [JavaScript and TypeScript Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/JavaScript_and_TypeScript_Security_Cheat_Sheet.html)
- MDN, [Content Security Policy guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP)
