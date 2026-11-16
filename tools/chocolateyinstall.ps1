$ErrorActionPreference = 'Stop'

$version = $env:ChocolateyPackageVersion

# The community repository validator requires the checksum and the URL of each download to be
# visible as literals, so the checksum is passed inline instead of a hashtable lookup (rule
# cpmr0073), and only one version is accepted at a time.
if ($version -ne '1.0.6') {
    throw "No literal checksum registered for $version - add a block to tools\chocolateyinstall.ps1 before pushing this version."
}

$packageArgs = @{
    packageName    = 'sonicaura'
    fileType       = 'exe'
    url            = 'https://sonicaura.app/bin/SonicAura-Setup-1.0.6.exe'
    checksum       = '57c78a2dbe8f9ec507658997e53f942a912b46d572f61732c05cd5a87588f711'
    checksumType   = 'sha256'
    silentArgs     = '/S /allusers'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

$roots = @(
    (Join-Path $env:ProgramFiles 'SonicAura'),
    (Join-Path ${env:ProgramFiles(x86)} 'SonicAura'),
    (Join-Path $env:LOCALAPPDATA 'Programs\SonicAura')
)

$exe = $null
foreach ($root in $roots) {
    if (-not $root) { continue }
    $candidate = Join-Path $root 'SonicAura.exe'
    if (Test-Path $candidate) { $exe = $candidate; break }
}

if ($exe) {
    Install-BinFile -Name 'sonicaura' -Path $exe
}

