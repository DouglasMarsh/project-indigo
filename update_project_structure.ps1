param (
    [string]$ProjectRoot = "."
)

$ProjectRoot = $ProjectRoot.TrimEnd('\','/')

$YamlFile = Join-Path $ProjectRoot "project_structure.yaml"
if (-not (Test-Path $YamlFile)) {
    Write-Error "❌ project_structure.yaml not found in $ProjectRoot"
    exit 1
}

$TempFile = New-TemporaryFile
Add-Content $TempFile "structure:"

# --- Add root-level files ---
Get-ChildItem -Path $ProjectRoot -File | Sort-Object Name | ForEach-Object {
    Add-Content $TempFile "  - $($_.Name)"
}

# --- Recursive YAML generator function ---
function Write-YamlRecursive {
    param (
        [string]$FolderPath,
        [string]$Indent = "  "
    )

    Get-ChildItem -Path $FolderPath | Sort-Object Name | ForEach-Object {
        if ($_.PSIsContainer) {
            Add-Content $TempFile "$Indent- $($_.Name):"
            Write-YamlRecursive -FolderPath $_.FullName -Indent ("  $Indent")
        }
        elseif ($_.Attributes -notmatch "Directory") {
            Add-Content $TempFile "$Indent- $($_.Name)"
        }
    }
}

# --- Add root-level folders ---
Get-ChildItem -Path $ProjectRoot -Directory | Sort-Object Name | ForEach-Object {
    Add-Content $TempFile "  - $($_.Name):"
    Write-YamlRecursive -FolderPath $_.FullName -Indent "    "
}

# --- Backup original file ---
Copy-Item -Path $YamlFile -Destination "$YamlFile.bak" -Force

# --- Replace the structure block in the YAML ---
$NewYaml = @()
$InStructure = $false

Get-Content $YamlFile | ForEach-Object {
    if ($_ -match '^structure:') {
        $InStructure = $true
        $NewYaml += Get-Content $TempFile
        return
    }

    if ($InStructure -and ($_ -match '^[^ ]')) {
        $InStructure = $false
    }

    if (-not $InStructure) {
        $NewYaml += $_
    }
}

$NewYaml | Set-Content $YamlFile

# Cleanup
Remove-Item $TempFile

Write-Host "✅ project_structure.yaml updated (YAML with recursive folders)"
Write-Host "🛑 Backup saved as project_structure.yaml.bak"
