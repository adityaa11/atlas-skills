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

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Source skills directory does not exist: $sourceRoot"
}

if (-not (Test-Path -LiteralPath $consumerRoot -PathType Container)) {
    throw "Consumer repository does not exist: $consumerRoot"
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
        exit 0
    }

    throw "Refusing to replace existing path: $junctionPath"
}

if ($PSCmdlet.ShouldProcess($junctionPath, "Create junction to $sourceRoot")) {
    New-Item -ItemType Junction -Path $junctionPath -Target $sourceRoot | Out-Null
    Write-Output "Linked: $junctionPath -> $sourceRoot"
}
