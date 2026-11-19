# Atlas Skills

Reusable Atlas workflow skills and command-line setup for a separate artifact
repository. The code repository keeps source code; the artifact
repository stores durable contexts, tickets, checkpoints, reviews, and
authorizations.

## Prerequisites

- Git must be installed and available on `PATH`.
- The code repository and its artifact repository must both be cloned
  locally.
- On macOS and Linux, install PowerShell 7 (`pwsh`).

## Setup

### Windows

```powershell
.\atlas-skills.cmd export C:\Workspace\payments-service
```

### macOS

```bash
pwsh ./atlas-skills.ps1 export /workspace/payments-service
```

### Linux

```bash
pwsh ./atlas-skills.ps1 export /workspace/payments-service
```

The `export` command creates these files in the code repository:

```text
atlas-workflow.yaml         # commit this file
atlas-workflow.local.yaml   # local-only; ignored by Git
```

Update the tracked configuration with the canonical remote of the artifact
repository:

```yaml
# atlas-workflow.yaml
artifact_store:
  expected_remote: git@github.com:acme/payments-service-artifacts.git
```

Update the ignored local override with the local checkout path:

```yaml
# Windows: atlas-workflow.local.yaml
artifact_store:
  checkout_path: C:\Workspace\payments-service-artifacts
```

```yaml
# macOS/Linux: atlas-workflow.local.yaml
artifact_store:
  checkout_path: /workspace/payments-service-artifacts
```

Run the setup command after both YAML files are ready. It validates the current
configuration and Git remote, initializes the artifact store if necessary, and
mounts it at `.atlas` in the code repository.

### Windows

```powershell
.\atlas-skills.cmd init-artifacts C:\Workspace\payments-service
```

### macOS

```bash
pwsh ./atlas-skills.ps1 init-artifacts /workspace/payments-service
```

### Linux

```bash
pwsh ./atlas-skills.ps1 init-artifacts /workspace/payments-service
```

Windows uses a directory junction. macOS and Linux use a symbolic link.

## Resulting layout

```text
code-repo/
├─ .agents/skills/atlas-skills/  # local skill junction; ignored by Git
├─ .atlas/                       # mount to artifact repository; ignored by Git
├─ atlas-workflow.yaml            # tracked
└─ atlas-workflow.local.yaml      # ignored

artifact-repo/
├─ atlas-artifacts.yaml
├─ contexts/
├─ tickets/
├─ checkpoints/
├─ feedback/
└─ evidence/
```

## Commands

| Purpose | Windows | macOS / Linux |
| --- | --- | --- |
| Show help | `.\atlas-skills.cmd help` | `pwsh ./atlas-skills.ps1 help` |
| Export skills and config templates | `.\atlas-skills.cmd export <code-repo>` | `pwsh ./atlas-skills.ps1 export <code-repo>` |
| Initialize and mount artifact store | `.\atlas-skills.cmd init-artifacts <code-repo>` | `pwsh ./atlas-skills.ps1 init-artifacts <code-repo>` |
| Recreate a missing `.atlas` mount | `.\atlas-skills.cmd mount-artifacts <code-repo>` | `pwsh ./atlas-skills.ps1 mount-artifacts <code-repo>` |
| Validate skill definitions | `.\atlas-skills.cmd validate` | `pwsh ./atlas-skills.ps1 validate` |
| Show version | `.\atlas-skills.cmd version` | `pwsh ./atlas-skills.ps1 version` |

For private Git hosting, use the remote URL and credentials already configured
for the local Git checkout. Atlas Skills does not store or request credentials.
