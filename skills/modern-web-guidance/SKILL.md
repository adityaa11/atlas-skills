---
name: modern-web-guidance
description: Apply bundled HTML, CSS, DOM, and browser compatibility guidance to specific web implementation tasks or requested legacy scans. Do not use to define a project's visual language or information hierarchy.
---

# Modern Web Guidance

## Boundary with Frontend Awareness

This skill owns web platform mechanisms and browser support details. It does
not choose the product's visual language, information hierarchy, component
composition, or review outcome; use `frontend-awareness` when those UI decisions
are part of the task. A focused browser API or client-side behavior change can
use this skill alone.

Use the bundled GoogleChrome Modern Web Guidance CLI to find focused guidance
for a specific browser-facing task. Atlas exports the CLI and its guides with
this skill. The target repository needs no package installation or network
access. Running the CLI requires Node.js 22 or newer; the guides under
`vendor/modern-web-guidance/guides/` can also be read directly.

From the target repository, resolve this skill's directory and run its bundled
CLI. For a standard Atlas export, the commands are:

```shell
node .agents/skills/atlas-skills/modern-web-guidance/vendor/modern-web-guidance/modern-web.mjs search "responsive layout container queries"
node .agents/skills/atlas-skills/modern-web-guidance/vendor/modern-web-guidance/modern-web.mjs retrieve "size-aware-styling"
```

Some bundled guides link to related guides with `npx ...@latest` commands. Use
the bundled `retrieve` command above for those IDs too, so the guidance stays
on the Atlas-pinned version and works offline.

Use guides for browser implementation details within the user's request and
the project's browser support, framework, and conventions. For Atlas ticket
work, the frozen ticket and its accepted context set scope. Follow the project
visual contract and CSP when applicable. A guide does not add requirements,
authorize a dependency or new origin, or override those boundaries. Verify
support before using experimental or volatile features.

When the user asks to find legacy web patterns or modernization opportunities,
run a scan from the target repository and inspect its findings before editing:

```shell
node .agents/skills/atlas-skills/modern-web-guidance/vendor/modern-web-guidance/modern-web.mjs legacy-scan . --json
```

The Atlas export makes this skill discoverable. Do not use the upstream
`install`, `update`, or `uninstall` commands for this Atlas-managed copy.

This copy comes from `modern-web-guidance@1.0.1`:
https://github.com/GoogleChrome/modern-web-guidance-src. The upstream license
and third-party notices are in `vendor/LICENSE` and
`vendor/THIRD_PARTY_NOTICES`.
