# Rename IZY folders in parent directory

# Get the directory two levels above the script (mods)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$parentDir = Split-Path $scriptDir -Parent
$modsDir = Split-Path $parentDir -Parent
Set-Location $modsDir

Write-Host "Current directory: $modsDir"

$folders = Get-ChildItem -Directory -Name 'LittleRedSonja_Mumpfy_ArmorPack*'
if (-not $folders) {
    Write-Host "No folders found matching pattern LittleRedSonja_Mumpfy_ArmorPack*"
    Pause
    exit
}

$toRename = @()
foreach ($folder in $folders) {
    $newName = "0_z $folder"
    if (Test-Path $newName) {
        Write-Host "SKIP: $newName already exists"
    } else {
        Write-Host "$folder  ==>  $newName"
        $toRename += ,@($folder, $newName)
    }
}

if ($toRename.Count -eq 0) {
    Write-Host "No folders to rename."
    Pause
    exit
}

Write-Host "The above folders will be renamed."
$confirm = Read-Host "Proceed with rename? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Aborted."
    exit
}

foreach ($pair in $toRename) {
    $old = $pair[0]
    $new = $pair[1]
    try {
        Rename-Item -Path $old -NewName $new -ErrorAction Stop
    } catch {
        Write-Host "ERROR: Failed to rename $old"
    }
}

Write-Host "Rename complete."
