[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ConsumerRepo,

    [string] $SourceRepo
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($SourceRepo)) {
    $SourceRepo = Split-Path -Parent $PSScriptRoot
}

$sourceRoot = [System.IO.Path]::GetFullPath((Join-Path $SourceRepo 'skills'))
$consumerRoot = [System.IO.Path]::GetFullPath($ConsumerRepo)
$skillsRoot = Join-Path $consumerRoot '.agents\skills'
$junctionPath = Join-Path $skillsRoot 'atlas-skills'
$gitIgnorePath = Join-Path $consumerRoot '.gitignore'
$workflowConfigPath = Join-Path $consumerRoot 'atlas-workflow.yaml'
$localWorkflowConfigPath = Join-Path $consumerRoot 'atlas-workflow.local.yaml'
$templatePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'templates\atlas-workflow.yaml'
$localTemplatePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'templates\atlas-workflow.local.yaml'

function Add-AtlasGitIgnoreEntries {
    param([string] $Path)

    $entries = @(
        '.agents/skills/atlas-skills/',
        '.atlas/',
        'atlas-workflow.local.yaml'
    )

    [string[]] $existingLines = if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Get-Content -LiteralPath $Path
    } else {
        @()
    }

    $missingEntries = @($entries | Where-Object { $_ -notin $existingLines })
    if ($missingEntries.Count -eq 0) {
        return
    }

    if ($PSCmdlet.ShouldProcess($Path, 'Add Atlas-managed ignore entries')) {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
            New-Item -ItemType File -Path $Path | Out-Null
        }

        Add-Content -LiteralPath $Path -Value @(
            '',
            '# >>> atlas-skills >>>',
            '# Local junctions and machine-specific Atlas workflow settings.',
            $missingEntries,
            '# <<< atlas-skills >>>'
        )
        Write-Output "Updated ignore rules: $Path"
    }
}

function New-WorkflowConfigFromTemplate {
    param(
        [string] $TemplatePath,
        [string] $DestinationPath
    )

    if (Test-Path -LiteralPath $DestinationPath) {
        Write-Output "Workflow config already exists: $DestinationPath"
        return
    }

    if ($PSCmdlet.ShouldProcess($DestinationPath, 'Create Atlas workflow configuration template')) {
        Copy-Item -LiteralPath $TemplatePath -Destination $DestinationPath
        Write-Output "Created workflow config template: $DestinationPath"
    }
}

function Show-NextSteps {
    param(
        [string] $ConsumerRoot,
        [string] $WorkflowConfigPath
    )

    $relativeConfigPath = Split-Path -Leaf $WorkflowConfigPath
    @"

Atlas skills export is ready.

Next steps:
  1. Edit $relativeConfigPath and set artifact_store.expected_remote to the
     canonical remote of this project's artifact repository.
  2. Clone or create that artifact repository, then set
     artifact_store.checkout_path in atlas-workflow.local.yaml.
  3. Initialize and mount the configured artifact repository. This command
     validates the current YAML and checkout before writing anything, then
     verifies the completed store automatically:
     atlas-skills init-artifacts $ConsumerRoot
     (the mount is $(Join-Path $ConsumerRoot '.atlas'); Windows uses a junction and Unix uses a symlink).
  4. Commit $relativeConfigPath to this code repository.
  5. Keep machine-specific checkout paths only in atlas-workflow.local.yaml;
     it is ignored and must not be committed.
  6. Generate project, stack, or implementation context only after the .atlas
     artifact mount points to the intended artifact repository.
"@.TrimEnd()
}

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Source skills directory does not exist: $sourceRoot"
}

if (-not (Test-Path -LiteralPath $consumerRoot -PathType Container)) {
    throw "Consumer repository does not exist: $consumerRoot"
}

foreach ($requiredTemplate in @($templatePath, $localTemplatePath)) {
    if (-not (Test-Path -LiteralPath $requiredTemplate -PathType Leaf)) {
        throw "Workflow config template does not exist: $requiredTemplate"
    }
}

if (-not (Test-Path -LiteralPath $skillsRoot -PathType Container)) {
    if ($PSCmdlet.ShouldProcess($skillsRoot, 'Create .agents/skills directory')) {
        New-Item -ItemType Directory -Path $skillsRoot | Out-Null
    }
}

if (Test-Path -LiteralPath $junctionPath) {
    $existing = Get-Item -LiteralPath $junctionPath -Force
    $isJunction = ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
    $existingTarget = if ($isJunction) { $existing.Target } else { $null }

    if ($isJunction -and $existingTarget -and
        ([System.IO.Path]::GetFullPath($existingTarget) -eq $sourceRoot)) {
        Write-Output "Already linked: $junctionPath -> $sourceRoot"
    } else {
        throw "Refusing to replace existing path: $junctionPath"
    }
} else {
    if ($PSCmdlet.ShouldProcess($junctionPath, "Create junction to $sourceRoot")) {
        New-Item -ItemType Junction -Path $junctionPath -Target $sourceRoot | Out-Null
        Write-Output "Linked: $junctionPath -> $sourceRoot"
    }
}

Add-AtlasGitIgnoreEntries -Path $gitIgnorePath
New-WorkflowConfigFromTemplate -TemplatePath $templatePath -DestinationPath $workflowConfigPath
New-WorkflowConfigFromTemplate -TemplatePath $localTemplatePath -DestinationPath $localWorkflowConfigPath
Show-NextSteps -ConsumerRoot $consumerRoot -WorkflowConfigPath $workflowConfigPath
