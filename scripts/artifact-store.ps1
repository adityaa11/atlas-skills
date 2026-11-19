[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('init', 'validate', 'mount')]
    [string] $Action,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Target
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-ScalarYamlValue {
    param([string] $Path, [string] $Key)

    $match = [regex]::Match((Get-Content -LiteralPath $Path -Raw), "(?m)^\s*$([regex]::Escape($Key)):\s*(?<value>[^#\r\n]*)")
    if (-not $match.Success) { return '' }

    return $match.Groups['value'].Value.Trim().Trim('"').Trim("'")
}

function Invoke-Git {
    param([string] $Repository, [string[]] $Arguments)

    $output = & git -C $Repository @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Git command failed in ${Repository}: git $($Arguments -join ' ')`n$output"
    }

    return ($output | Out-String).Trim()
}

function Normalize-GitUrl {
    param([string] $Url)

    $normalized = $Url.Trim().TrimEnd('/')
    if ($normalized.EndsWith('.git', [StringComparison]::OrdinalIgnoreCase)) {
        $normalized = $normalized.Substring(0, $normalized.Length - 4)
    }

    if ($normalized -match '^(?:ssh://)?git@(?<host>[^/:]+)[:/](?<path>.+)$') {
        return "$($Matches.host.ToLowerInvariant())/$($Matches.path)"
    }

    if ($normalized -match '^(?:https?|ssh)://(?:[^@/]+@)?(?<host>[^/:]+)(?::\d+)?/(?<path>.+)$') {
        return "$($Matches.host.ToLowerInvariant())/$($Matches.path)"
    }

    return $normalized
}

function Get-WorkflowConfig {
    param([string] $ConsumerRoot)

    $configPath = Join-Path $ConsumerRoot 'atlas-workflow.yaml'
    if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
        throw "Missing workflow config: $configPath. Run atlas-skills export first."
    }

    $localPath = Join-Path $ConsumerRoot 'atlas-workflow.local.yaml'
    $expectedRemote = Get-ScalarYamlValue -Path $configPath -Key 'expected_remote'
    $checkoutPath = if (Test-Path -LiteralPath $localPath -PathType Leaf) {
        Get-ScalarYamlValue -Path $localPath -Key 'checkout_path'
    } else { '' }

    if ([string]::IsNullOrWhiteSpace($expectedRemote)) { throw "atlas-workflow.yaml must set artifact_store.expected_remote." }
    if ([string]::IsNullOrWhiteSpace($checkoutPath)) { throw "atlas-workflow.local.yaml must set artifact_store.checkout_path." }

    $resolvedCheckoutPath = if ([System.IO.Path]::IsPathRooted($checkoutPath)) {
        [System.IO.Path]::GetFullPath($checkoutPath)
    } else {
        [System.IO.Path]::GetFullPath((Join-Path $ConsumerRoot $checkoutPath))
    }

    return [pscustomobject]@{
        ConfigPath = $configPath
        LocalPath = $localPath
        MountPath = [System.IO.Path]::GetFullPath((Join-Path $ConsumerRoot '.atlas'))
        ExpectedRemote = $expectedRemote
        CheckoutPath = $resolvedCheckoutPath
    }
}

function Test-ArtifactStore {
    param(
        [string] $ConsumerRoot,
        [switch] $RequireMount,
        [switch] $RequireInitialized
    )

    Invoke-Git -Repository $ConsumerRoot -Arguments @('rev-parse', '--is-inside-work-tree') | Out-Null
    $config = Get-WorkflowConfig -ConsumerRoot $ConsumerRoot

    if (-not (Test-Path -LiteralPath $config.CheckoutPath -PathType Container)) {
        throw "Artifact checkout does not exist: $($config.CheckoutPath)"
    }

    Invoke-Git -Repository $config.CheckoutPath -Arguments @('rev-parse', '--is-inside-work-tree') | Out-Null
    $actualRemote = Invoke-Git -Repository $config.CheckoutPath -Arguments @('remote', 'get-url', 'origin')
    if ((Normalize-GitUrl $actualRemote) -ne (Normalize-GitUrl $config.ExpectedRemote)) {
        throw "Artifact remote mismatch. Expected '$($config.ExpectedRemote)', found '$actualRemote'."
    }

    $manifestPath = Join-Path $config.CheckoutPath 'atlas-artifacts.yaml'
    $initialized = Test-Path -LiteralPath $manifestPath -PathType Leaf
    if (-not $initialized -and $RequireInitialized) {
        throw "Missing artifact manifest: $manifestPath. Run atlas-skills init-artifacts first."
    }

    if ($initialized) {
        $layout = Get-ScalarYamlValue -Path $manifestPath -Key 'layout'
        if ($layout -ne 'atlas-workflow') {
            throw "Unsupported artifact-store layout '$layout' in $manifestPath."
        }
    }

    if (Test-Path -LiteralPath $config.MountPath) {
        $mounted = Get-Item -LiteralPath $config.MountPath -Force
        $isLink = ($mounted.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
        $mountedTarget = if ($isLink) { [System.IO.Path]::GetFullPath($mounted.Target) } else { '' }
        if (-not $isLink -or $mountedTarget -ne $config.CheckoutPath) {
            throw "Artifact mount conflicts with configured checkout: $($config.MountPath)"
        }
    } elseif ($RequireMount) {
        throw "Artifact mount is missing: $($config.MountPath). Run atlas-skills mount-artifacts."
    }

    $config | Add-Member -NotePropertyName Initialized -NotePropertyValue $initialized
    return $config
}

function Initialize-ArtifactStore {
    param([string] $ArtifactRoot)

    $root = [System.IO.Path]::GetFullPath($ArtifactRoot)

    Invoke-Git -Repository $root -Arguments @('rev-parse', '--is-inside-work-tree') | Out-Null
    $manifestPath = Join-Path $root 'atlas-artifacts.yaml'
    $templatePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'templates\atlas-artifacts.yaml'
    if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) { throw "Missing template: $templatePath" }

    if (-not (Test-Path -LiteralPath $manifestPath)) {
        if ($PSCmdlet.ShouldProcess($manifestPath, 'Create artifact-store manifest')) {
            Copy-Item -LiteralPath $templatePath -Destination $manifestPath
        }
    }

    foreach ($directory in @('contexts', 'contexts\implementation', 'tickets', 'checkpoints', 'feedback', 'evidence')) {
        $path = Join-Path $root $directory
        if (-not (Test-Path -LiteralPath $path -PathType Container) -and $PSCmdlet.ShouldProcess($path, 'Create artifact directory')) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
        }

        $placeholder = Join-Path $path '.gitkeep'
        if (-not (Test-Path -LiteralPath $placeholder -PathType Leaf) -and $PSCmdlet.ShouldProcess($placeholder, 'Create layout placeholder')) {
            New-Item -ItemType File -Path $placeholder | Out-Null
        }
    }

    Write-Output "Artifact store initialized at: $root"
    Write-Output 'Review and commit the manifest and directories in the artifact repository before creating durable artifacts.'
}

function Mount-ArtifactStore {
    param([string] $ConsumerRoot)

    $config = Test-ArtifactStore -ConsumerRoot $ConsumerRoot -RequireInitialized
    if (Test-Path -LiteralPath $config.MountPath) {
        Write-Output "Already mounted: $($config.MountPath) -> $($config.CheckoutPath)"
        return
    }

    $parent = Split-Path -Parent $config.MountPath
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        if ($PSCmdlet.ShouldProcess($parent, 'Create artifact-mount parent directory')) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
    }

    $itemType = if ($env:OS -eq 'Windows_NT') { 'Junction' } else { 'SymbolicLink' }
    if ($PSCmdlet.ShouldProcess($config.MountPath, "Create $itemType to $($config.CheckoutPath)")) {
        New-Item -ItemType $itemType -Path $config.MountPath -Target $config.CheckoutPath | Out-Null
        Write-Output "Mounted: $($config.MountPath) -> $($config.CheckoutPath)"
    }
}

switch ($Action) {
    'init' {
        $consumerRoot = [System.IO.Path]::GetFullPath($Target)
        $config = Test-ArtifactStore -ConsumerRoot $consumerRoot
        Initialize-ArtifactStore -ArtifactRoot $config.CheckoutPath
        $readyConfig = Test-ArtifactStore -ConsumerRoot $consumerRoot -RequireInitialized
        Write-Output "Artifact store ready: $($readyConfig.CheckoutPath)"
        Mount-ArtifactStore -ConsumerRoot $consumerRoot
    }
    'validate' {
        $consumerRoot = [System.IO.Path]::GetFullPath($Target)
        $config = Test-ArtifactStore -ConsumerRoot $consumerRoot
        if ($config.Initialized) {
            Write-Output "Artifact store ready: $($config.CheckoutPath)"
        } else {
            Write-Output "Artifact checkout valid but not initialized: $($config.CheckoutPath)"
            Write-Output "Next: atlas-skills init-artifacts $consumerRoot"
        }
    }
    'mount' { Mount-ArtifactStore -ConsumerRoot ([System.IO.Path]::GetFullPath($Target)) }
}
