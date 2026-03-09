$ErrorActionPreference = "Stop"

$NodeVersion = "25.8.0"
$OpenClawPackage = "openclaw@latest"

$LocalPrefix = Join-Path $env:LOCALAPPDATA "ClawForge"
$BinDir = Join-Path $LocalPrefix "bin"
$NodeRoot = Join-Path $LocalPrefix "nodejs"
$TempDir = Join-Path $env:TEMP ("clawforge-" + [guid]::NewGuid().ToString())

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "[ERROR] $msg" -ForegroundColor Red }

function Fail($msg) {
    Write-Err $msg
    exit 1
}

function Ensure-Dirs {
    New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
    New-Item -ItemType Directory -Force -Path $NodeRoot | Out-Null
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
}

function Install-Git {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        return
    }

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Info "Installing Git via winget..."
        winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
    } else {
        Fail "Git not found and winget is unavailable"
    }

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        $possibleGitPaths = @(
            "C:\Program Files\Git\cmd",
            "C:\Program Files\Git\bin"
        )

        foreach ($p in $possibleGitPaths) {
            if (Test-Path (Join-Path $p "git.exe")) {
                $env:PATH = "$p;$env:PATH"
                break
            }
        }
    }

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Fail "Git installation failed or git is not available in PATH"
    }
}

function Get-NodeArchiveInfo {
    switch ($env:PROCESSOR_ARCHITECTURE) {
        "AMD64" { $nodeArch = "x64" }
        "ARM64" { $nodeArch = "arm64" }
        default { Fail "Unsupported architecture: $($env:PROCESSOR_ARCHITECTURE)" }
    }

    $extractedDir = "node-v$NodeVersion-win-$nodeArch"
    $fileName = "$extractedDir.zip"
    $url = "https://nodejs.org/dist/v$NodeVersion/$fileName"

    return @{
        NodeArch      = $nodeArch
        ExtractedDir  = $extractedDir
        FileName      = $fileName
        Url           = $url
    }
}

function Install-Node {
    $archive = Get-NodeArchiveInfo
    $NodeInstallDir = Join-Path $NodeRoot $archive.ExtractedDir
    $nodeExe = Join-Path $NodeInstallDir "node.exe"

    if (Test-Path $nodeExe) {
        Write-Info "Node.js $NodeVersion already installed"
    } else {
        $zipPath = Join-Path $TempDir $archive.FileName

        Write-Info "Downloading Node.js $NodeVersion..."
        Invoke-WebRequest -Uri $archive.Url -OutFile $zipPath

        Write-Info "Installing Node.js $NodeVersion..."
        Expand-Archive -Path $zipPath -DestinationPath $NodeRoot -Force
    }

    $script:NodeInstallDir = $NodeInstallDir
    $script:NodeExe = Join-Path $NodeInstallDir "node.exe"
    $script:NpmCmd = Join-Path $NodeInstallDir "npm.cmd"
    $script:NpxCmd = Join-Path $NodeInstallDir "npx.cmd"

    if (-not (Test-Path $script:NodeExe)) { Fail "node.exe not found after install" }
    if (-not (Test-Path $script:NpmCmd)) { Fail "npm.cmd not found after install" }
    if (-not (Test-Path $script:NpxCmd)) { Fail "npx.cmd not found after install" }

    $env:PATH = "$NodeInstallDir;$BinDir;$env:PATH"
}

function Set-UserPath {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $parts = @()

    if ($userPath) {
        $parts = $userPath -split ";" | Where-Object { $_ -and $_.Trim() -ne "" }
    }

    if ($parts -notcontains $BinDir) {
        $parts += $BinDir
    }

    if ($parts -notcontains $NodeInstallDir) {
        $parts += $NodeInstallDir
    }

    $newPath = ($parts | Select-Object -Unique) -join ";"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

    $env:PATH = "$NodeInstallDir;$BinDir;$env:PATH"
}

function Configure-NpmPrefix {
    & $script:NpmCmd config set prefix $LocalPrefix | Out-Null
}

function Force-GitHubHttps {
    Write-Info "Configuring git to use HTTPS instead of SSH for GitHub..."
    git config --global url."https://github.com/".insteadOf "ssh://git@github.com/"
    git config --global url."https://github.com/".insteadOf "git@github.com:"
}

function Cleanup-FailedGlobalInstall {
    $moduleDir = Join-Path $LocalPrefix "node_modules\openclaw"
    $shimCmd = Join-Path $LocalPrefix "openclaw.cmd"
    $shimPs1 = Join-Path $LocalPrefix "openclaw.ps1"
    $binWrapper = Join-Path $BinDir "openclaw.cmd"

    if (Test-Path $moduleDir) { Remove-Item -Recurse -Force $moduleDir -ErrorAction SilentlyContinue }
    if (Test-Path $shimCmd) { Remove-Item -Force $shimCmd -ErrorAction SilentlyContinue }
    if (Test-Path $shimPs1) { Remove-Item -Force $shimPs1 -ErrorAction SilentlyContinue }
    if (Test-Path $binWrapper) { Remove-Item -Force $binWrapper -ErrorAction SilentlyContinue }
}

function Install-OpenClaw {
    Write-Info "Installing OpenClaw..."
    Cleanup-FailedGlobalInstall
    & $script:NpmCmd install -g $OpenClawPackage
}

function Create-Wrapper {
    $target = Join-Path $LocalPrefix "openclaw.cmd"
    if (-not (Test-Path $target)) {
        $target = Join-Path $BinDir "openclaw.cmd"
    }

    if (-not (Test-Path $target)) {
        Fail "openclaw.cmd not found after npm install"
    }

    $wrapper = Join-Path $BinDir "openclaw.cmd"

    $content = @"
@echo off
setlocal
set PATH=$NodeInstallDir;$BinDir;%PATH%
call "$target" %*
"@

    Set-Content -Path $wrapper -Value $content -Encoding ASCII
}

function Verify-Install {
    $wrapper = Join-Path $BinDir "openclaw.cmd"

    if (-not (Test-Path $wrapper)) { Fail "openclaw.cmd wrapper not found after install" }

    $nodeVersionOut = & $script:NodeExe -v
    $npmVersionOut = & $script:NpmCmd -v

    Write-Info "Node: $nodeVersionOut"
    Write-Info "npm: $npmVersionOut"
    Write-Info "OpenClaw wrapper: $wrapper"
}

try {
    Write-Host "======================================"
    Write-Host "ClawForge Installer"
    Write-Host "OpenClaw AI Agent Setup"
    Write-Host "======================================"
    Write-Host ""

    Ensure-Dirs
    Install-Git
    Install-Node
    Set-UserPath
    Configure-NpmPrefix
    Force-GitHubHttps
    Install-OpenClaw
    Create-Wrapper
    Verify-Install

    Write-Host ""
    Write-Host "OpenClaw installed."
    Write-Host ""
    Write-Host "Next step:"
    Write-Host ""
    Write-Host "  openclaw onboard --install-daemon"
    Write-Host ""
    Write-Host "If the current terminal still can't find openclaw, restart PowerShell."
}
finally {
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
    }
}