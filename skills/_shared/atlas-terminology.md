# Atlas Terminology

Use these terms consistently in every Atlas skill, artifact, command, and
message.

| Term | Meaning |
| --- | --- |
| **skills repository** | The reusable `atlas-skills` Git repository. It contains skill definitions, scripts, templates, and shared contracts. |
| **code repository** | The Git repository containing the product's source code, tests, and application configuration. It was previously called the actual-code, target, or consumer repository. |
| **artifact repository** | The separate Git repository containing durable Atlas artifacts for one code repository. |
| **artifact checkout** | A local Git checkout of the artifact repository. Its path is configured in `atlas-workflow.local.yaml`. |
| **artifact mount** | The `.atlas` directory in the code repository. It is a junction on Windows or a symbolic link on Unix-like systems to the artifact checkout. |
| **code commit** | A commit in the code repository containing source code, tests, or application configuration. |
| **artifact commit** | A commit in the artifact repository containing contexts, tickets, checkpoints, reviews, authorizations, or evidence metadata. |

Never use `target repository`, `consumer repository`, or `actual-code
repository` for the code repository. A command argument named
`<code-repository>` always means the root of the code repository, never the
artifact checkout.
