$Repo = "https://github.com/openclaw/openclaw.git"
$InstallDir = "$env:LOCALAPPDATA\OpenClaw"
$BinDir = "$env:LOCALAPPDATA\OpenClaw\bin"

Write-Host "ClawForge Installer"
Write-Host "OpenClaw AI Agent Setup"
Write-Host ""

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
Write-Host "Git not found"
exit
}

if (!(Get-Command node -ErrorAction SilentlyContinue)) {

Write-Host "Installing Node.js via winget..."

winget install OpenJS.NodeJS

}

if (Test-Path $InstallDir) {

git -C $InstallDir pull

}
else {

git clone $Repo $InstallDir

}

cd $InstallDir

npm install

if (!(Test-Path $BinDir)) {

New-Item -ItemType Directory -Path $BinDir | Out-Null

}

$wrapper = Join-Path $BinDir "openclaw.cmd"

$cmd = "@echo off`ncd /d `"$InstallDir`"`nnpm start"

Set-Content $wrapper $cmd

$path = [Environment]::GetEnvironmentVariable("PATH","User")

if ($path -notlike "*$BinDir*") {

[Environment]::SetEnvironmentVariable("PATH","$path;$BinDir","User")

}

Write-Host ""
Write-Host "OpenClaw installed."
Write-Host ""
Write-Host "Restart terminal then run:"
Write-Host ""
Write-Host "openclaw"