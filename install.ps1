$ErrorActionPreference = "Stop"

$NodeVersion = "25.8.0"
$OpenClawPackage = "openclaw@latest"

$LocalPrefix = Join-Path $env:LOCALAPPDATA "ClawForge"
$BinDir = Join-Path $LocalPrefix "bin"
$NodeRoot = Join-Path $LocalPrefix "nodejs"
$NodeInstallDir = Join-Path $NodeRoot "node-v$NodeVersion"
$TempDir = Join-Path $env:TEMP ("clawforge-" + [guid]::NewGuid().ToString())

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "[ERROR] $msg" -ForegroundColor Red }

function Fail($msg) {
    Write-Err $msg
    exit 1
}

function Require-Command($name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        Fail "Missing command: $name"
    }
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
        $gitCmd = Get-ChildItem "C:\Program Files\Git\cmd\git.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($gitCmd) {
            $env:PATH = "C:\Program Files\Git\cmd;$env:PATH"
        }
    }

    Require-Command git
}

function Get-NodeArchiveInfo {
    $arch = $env:PROCESSOR_ARCHITECTURE
    switch ($arch) {
        "AMD64" { $nodeArch = "x64" }
        "ARM64" { $nodeArch = "arm64" }
        default { Fail "Unsupported architecture: $arch" }
    }

    $fileName = "node-v$NodeVersion-win-$nodeArch.zip"
    $url = "https://nodejs.org/dist/v$NodeVersion/$fileName"

    return @{
        FileName = $fileName
        Url = $url
    }
}

function Install-Node {
    $nodeExe = Join-Path $NodeInstallDir "node.exe"

    if (Test-Path $nodeExe) {
        Write-Info "Node.js $NodeVersion already installed"
    } else {
        $archive = Get-NodeArchiveInfo
        $zipPath = Join-Path $TempDir $archive.FileName

        Write-Info "Downloading Node.js $NodeVersion..."
        Invoke-WebRequest -Uri $archive.Url -OutFile $zipPath

        Write-Info "Installing Node.js $NodeVersion..."
        Expand-Archive -Path $zipPath -DestinationPath $NodeRoot -Force
    }

    $npmCmd = Join-Path $NodeInstallDir "npm.cmd"
    $npxCmd = Join-Path $NodeInstallDir "npx.cmd"
    $corepackCmd = Join-Path $NodeInstallDir "corepack.cmd"

    if (-not (Test-Path $nodeExe))  { Fail "node.exe not found after install" }
    if (-not (Test-Path $npmCmd))   { Fail "npm.cmd not found after install" }
    if (-not (Test-Path $npxCmd))   { Fail "npx.cmd not found after install" }
    if (-not (Test-Path $corepackCmd)) { Fail "corepack.cmd not found after install" }

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
    $npmCmd = Join-Path $NodeInstallDir "npm.cmd"
    & $npmCmd config set prefix $LocalPrefix | Out-Null
}

function Enable-Corepack {
    $corepackCmd = Join-Path $NodeInstallDir "corepack.cmd"
    & $corepackCmd enable | Out-Null
}

function Install-OpenClaw {
    $npmCmd = Join-Path $NodeInstallDir "npm.cmd"
    Write-Info "Installing OpenClaw..."
    & $npmCmd install -g $OpenClawPackage
}

function Create-Wrapper {
    $wrapper = Join-Path $BinDir "openclaw.cmd"
    $target = Join-Path $LocalPrefix "openclaw.cmd"

    if (-not (Test-Path $target)) {
        $target = Join-Path $BinDir "openclaw.cmd"
    }

    $content = @"
@echo off
setlocal
set PATH=$NodeInstallDir;$BinDir;%PATH%
"$target" %*
"@

    Set-Content -Path $wrapper -Value $content -Encoding ASCII
}

function Verify-Install {
    $openclawCmd = Join-Path $BinDir "openclaw.cmd"
    $nodeExe = Join-Path $NodeInstallDir "node.exe"
    $npmCmd = Join-Path $NodeInstallDir "npm.cmd"

    if (-not (Test-Path $openclawCmd)) { Fail "openclaw.cmd not found after install" }

    $nodeVersion = & $nodeExe -v
    $npmVersion = & $npmCmd -v

    Write-Info "Node: $nodeVersion"
    Write-Info "npm: $npmVersion"
    Write-Info "OpenClaw wrapper: $openclawCmd"
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
    Enable-Corepack
    Install-OpenClaw
    Create-Wrapper
    Verify-Install

    Write-Host ""
    Write-Info "Install complete."
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
