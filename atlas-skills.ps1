[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0)]
    [string] $Command = 'help',

    [Parameter(Position = 1)]
    [string] $CodeRepo,

    [Alias('h', 'help')]
    [switch] $HelpRequested,

    [Alias('v', 'version')]
    [switch] $VersionRequested
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$normalizedCommand = $Command.Trim().ToLowerInvariant()
$version = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'VERSION') -Raw).Trim()
if ([string]::IsNullOrWhiteSpace($version)) {
    throw 'VERSION file is empty.'
}

if ($HelpRequested) {
    $normalizedCommand = 'help'
}

if ($VersionRequested) {
    $normalizedCommand = 'version'
}

function Show-Help {
    @"
atlas-skills commands

  .\atlas-skills.cmd help | --help | -h
      Show this help.

  .\atlas-skills.cmd export <code-repository>
      Link this repository's skills into and bootstrap Atlas workflow files in:
      <code-repository>\.agents\skills\atlas-skills
      Creates missing .gitignore entries and atlas-workflow.yaml without
      overwriting existing files.

  .\atlas-skills.cmd init-artifacts <code-repository>
      Initialize and mount the configured artifact checkout using its YAML configuration.

  .\atlas-skills.cmd mount-artifacts <code-repository>
      Re-mount the configured artifact checkout at .atlas if its mount is missing.

  .\atlas-skills.cmd validate
      Validate every skill under .\skills.

  .\atlas-skills.cmd install
      Add the atlas-skills command to the user's PowerShell profiles.

  .\atlas-skills.cmd version | --version | -v
      Show the atlas-skills version.

Examples:

  .\atlas-skills.cmd help
  .\atlas-skills.cmd export C:\Workspace\atlas\ces-platform
  .\atlas-skills.cmd init-artifacts C:\Workspace\atlas\ces-platform
  .\atlas-skills.cmd mount-artifacts C:\Workspace\atlas\ces-platform
  .\atlas-skills.cmd export C:\Workspace\other-repo
  .\atlas-skills.cmd validate
  .\atlas-skills.cmd install
  .\atlas-skills.cmd version
"@
}

function Test-Skills {
    $skillsRoot = Join-Path $PSScriptRoot 'skills'
    $skillDirectories = @(Get-ChildItem -LiteralPath $skillsRoot -Directory -ErrorAction SilentlyContinue |
        Where-Object { -not $_.Name.StartsWith('_') })

    if ($skillDirectories.Count -eq 0) {
        throw "No skills found under $skillsRoot"
    }

    $seenNames = @{}
    $failed = $false

    foreach ($directory in $skillDirectories) {
        $skillPath = Join-Path $directory.FullName 'SKILL.md'
        if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) {
            Write-Output "FAIL  $($directory.Name): missing SKILL.md"
            $failed = $true
            continue
        }

        $content = Get-Content -LiteralPath $skillPath -Raw
        $frontMatter = [regex]::Match($content, '(?ms)^---\s*\r?\n(?<body>.*?)\r?\n---\s*')
        if (-not $frontMatter.Success) {
            Write-Output "FAIL  $($directory.Name): missing YAML frontmatter"
            $failed = $true
            continue
        }

        $body = $frontMatter.Groups['body'].Value
        $nameMatch = [regex]::Match($body, '(?m)^name:\s*(?<value>[^\r\n]+)\s*$')
        $descriptionMatch = [regex]::Match($body, '(?m)^description:\s*(?<value>[^\r\n]+)\s*$')
        $skillName = if ($nameMatch.Success) { $nameMatch.Groups['value'].Value.Trim() } else { '' }
        $description = if ($descriptionMatch.Success) { $descriptionMatch.Groups['value'].Value.Trim() } else { '' }

        if ($skillName -notmatch '^[a-z0-9-]+$') {
            Write-Output "FAIL  $($directory.Name): invalid or missing name"
            $failed = $true
            continue
        }

        if ([string]::IsNullOrWhiteSpace($description)) {
            Write-Output "FAIL  $($directory.Name): invalid or missing description"
            $failed = $true
            continue
        }

        if ($seenNames.ContainsKey($skillName)) {
            Write-Output "FAIL  $($directory.Name): duplicate skill name '$skillName'"
            $failed = $true
            continue
        }

        $seenNames[$skillName] = $true
        Write-Output "PASS  $skillName"
    }

    if ($failed) {
        throw 'Skill validation failed. Fix every FAIL row, then run validate again.'
    }

    Write-Output "[atlas-skills] SUCCESS: Validated $($seenNames.Count) skill(s)."
}

function Install-Command {
    $startMarker = '# >>> atlas-skills >>>'
    $endMarker = '# <<< atlas-skills <<<'
    $profilePaths = @(
        $PROFILE
        (Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1')
        (Join-Path $HOME 'Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1')
    ) | Select-Object -Unique
    $commandPath = (Join-Path $PSScriptRoot 'atlas-skills.cmd').Replace("'", "''")
    $installedPaths = @()
    $existingPaths = @()

    foreach ($profilePath in $profilePaths) {
        $profileDirectory = Split-Path -Parent $profilePath

        if (-not (Test-Path -LiteralPath $profileDirectory -PathType Container)) {
            New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
        }

        [string] $profileContent = if (Test-Path -LiteralPath $profilePath -PathType Leaf) {
            Get-Content -LiteralPath $profilePath -Raw
        } else {
            ''
        }

        if ($profileContent.Contains($startMarker) -or $profileContent.Contains($endMarker)) {
            $existingPaths += $profilePath
            continue
        }

        $profileBlock = @"
$startMarker
function atlas-skills {
    & '$commandPath' @args
}
$endMarker
"@

        Add-Content -LiteralPath $profilePath -Value ("`r`n" + $profileBlock)
        $installedPaths += $profilePath
    }

    foreach ($profilePath in $installedPaths) {
        Write-Output "Installed atlas-skills command in: $profilePath"
    }

    foreach ($profilePath in $existingPaths) {
        Write-Output "Already installed in: $profilePath"
    }

    Write-Output '[atlas-skills] SUCCESS: Command installation completed. Open a new PowerShell terminal, or run: . $PROFILE'
}

try {
switch ($normalizedCommand) {
    '/help' { Show-Help; exit 0 }
    'help' { Show-Help; exit 0 }
    '-help' { Show-Help; exit 0 }
    '--help' { Show-Help; exit 0 }
    '-h' { Show-Help; exit 0 }
    'version' { Write-Output "[atlas-skills] SUCCESS: atlas-skills $version"; exit 0 }
    '--version' { Write-Output "[atlas-skills] SUCCESS: atlas-skills $version"; exit 0 }
    '-v' { Write-Output "[atlas-skills] SUCCESS: atlas-skills $version"; exit 0 }
    'validate' { Test-Skills; exit 0 }
    'install' { Install-Command; exit 0 }
    '/export' {
        if ([string]::IsNullOrWhiteSpace($CodeRepo)) {
            [Console]::Error.WriteLine('[atlas-skills] ERROR: Usage: .\atlas-skills.cmd export <code-repository>')
            [Console]::Error.WriteLine('[atlas-skills] NEXT: Provide the root path of the code repository.')
            exit 2
        }

        & (Join-Path $PSScriptRoot 'scripts\link-skills.ps1') -CodeRepo $CodeRepo
        Write-Output "[atlas-skills] SUCCESS: Export completed for $CodeRepo"
        exit 0
    }
    'export' {
        if ([string]::IsNullOrWhiteSpace($CodeRepo)) {
            [Console]::Error.WriteLine('[atlas-skills] ERROR: Usage: .\atlas-skills.cmd export <code-repository>')
            [Console]::Error.WriteLine('[atlas-skills] NEXT: Provide the root path of the code repository.')
            exit 2
        }

        & (Join-Path $PSScriptRoot 'scripts\link-skills.ps1') -CodeRepo $CodeRepo
        Write-Output "[atlas-skills] SUCCESS: Export completed for $CodeRepo"
        exit 0
    }
    'init-artifacts' {
        if ([string]::IsNullOrWhiteSpace($CodeRepo)) {
            [Console]::Error.WriteLine('[atlas-skills] ERROR: Usage: .\atlas-skills.cmd init-artifacts <code-repository>')
            [Console]::Error.WriteLine('[atlas-skills] NEXT: Provide the root path of the code repository.')
            exit 2
        }

        & (Join-Path $PSScriptRoot 'scripts\artifact-store.ps1') -Action init -CodeRepo $CodeRepo
        Write-Output "[atlas-skills] SUCCESS: Artifact store initialized and mounted for $CodeRepo"
        exit 0
    }
    'mount-artifacts' {
        if ([string]::IsNullOrWhiteSpace($CodeRepo)) {
            [Console]::Error.WriteLine('[atlas-skills] ERROR: Usage: .\atlas-skills.cmd mount-artifacts <code-repository>')
            [Console]::Error.WriteLine('[atlas-skills] NEXT: Provide the root path of the code repository.')
            exit 2
        }

        & (Join-Path $PSScriptRoot 'scripts\artifact-store.ps1') -Action mount -CodeRepo $CodeRepo
        Write-Output "[atlas-skills] SUCCESS: Artifact store mounted for $CodeRepo"
        exit 0
    }
    default {
        [Console]::Error.WriteLine("[atlas-skills] ERROR: Unknown command '$Command'. Run .\atlas-skills.cmd help.")
        [Console]::Error.WriteLine('[atlas-skills] NEXT: Choose a command listed in atlas-skills help.')
        exit 2
    }
}
} catch {
    [Console]::Error.WriteLine("[atlas-skills] ERROR: $($_.Exception.Message)")
    [Console]::Error.WriteLine('[atlas-skills] NEXT: Correct the reported configuration or repository state, then rerun the command.')
    exit 1
}
