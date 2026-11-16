$ErrorActionPreference = 'Stop'

Uninstall-BinFile -Name 'sonicaura'

$programFiles = $env:ProgramW6432
if (-not $programFiles) { $programFiles = $env:ProgramFiles }

$installDir = Join-Path $programFiles 'SonicAura'
$uninstaller = Join-Path $installDir 'Uninstall SonicAura.exe'

if (Test-Path $uninstaller) {
    $process = Start-Process $uninstaller -ArgumentList '/S', '/allusers' -Wait -PassThru
    if ($process.ExitCode -notin @(0, 3010)) {
        throw "Uninstaller exited with code $($process.ExitCode)."
    }
}

if (Test-Path $installDir) {
    Remove-Item $installDir -Recurse -Force -ErrorAction SilentlyContinue
}
