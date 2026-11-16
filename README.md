# SonicAura - Chocolatey package

Community package for [SonicAura](https://sonicaura.app), an audio-reactive desktop aura for Windows: it
paints reactive auras on the desktop that follow whatever is playing, from any player or browser tab.

- Download URL: `https://sonicaura.app/bin/SonicAura-Setup-<version>.exe` (versioned - preferred, because a
  replaced asset cannot silently change the file behind the same URL)
- Installer: electron-builder (NSIS)

## Install behaviour

- `Install-ChocolateyPackage -fileType exe` runs the installer with `/S /allusers`, so the application
  lands in `C:\Program Files\SonicAura`.
- `Install-BinFile` adds the `sonicaura` shim, looking for `SonicAura.exe` in `Program Files`,
  `Program Files (x86)` and `%LOCALAPPDATA%\Programs` (per-user fallback).
- The uninstaller is the NSIS one that Electron writes (`Uninstall SonicAura.exe`).

## Checksums

The checksum is a literal inline in `tools\chocolateyinstall.ps1`. The community repository validation rule
cpmr0073 requires the URL and the checksum to be visible as literals - a hashtable lookup is reported as
"downloaded without validating the checksum". The script also refuses to run for a version it has no literal
for, so an accidental bump cannot install an unverified download.

`licenseUrl` points to `https://sonicaura.app/eula` because the nuspec validation (cpmr0038) rejects a
`licenseUrl` identical to `projectUrl`.

## Build and push

```powershell
choco pack
choco apikey --key <API_KEY> --source https://push.chocolatey.org/
choco push sonicaura.1.0.6.nupkg --source https://push.chocolatey.org/
```

## Bumping the version

1. Read the new SHA256 from the published binary (`Get-FileHash SonicAura-Setup-<version>.exe -Algorithm SHA256`).
2. Update `version` in `sonicaura.nuspec`, the URL and the literal + version guard in
   `tools\chocolateyinstall.ps1`.
3. `choco pack` and push.

## Verified (1.0.6)

- The installer was run directly with the exact silent arguments used by the package: exit code `0` in 8.2 s,
  installed to `C:\Program Files\SonicAura`.
- `choco pack` succeeds and the nuspec validates.
