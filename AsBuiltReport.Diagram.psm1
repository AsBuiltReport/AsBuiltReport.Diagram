# Get assemblies files and import them
switch ($PSVersionTable.PSEdition) {
    'Core' {
        $assemblyPath = "$PSScriptRoot{0}Src{0}Bin{0}Assemblies{0}net80{0}Diagrammer.dll" -f [System.IO.Path]::DirectorySeparatorChar
        if (-not (Test-Path -Path $assemblyPath)) {
            throw "Required assembly not found: '$assemblyPath'. Please run the build/publish step (e.g., 'dotnet publish') before importing this module."
        }
        Import-Module $assemblyPath
    }
    'Desktop' {
        $assemblyPath = "$PSScriptRoot{0}Src{0}Bin{0}Assemblies{0}net48{0}DiaConvertImageToPDF.dll" -f [System.IO.Path]::DirectorySeparatorChar
        if (-not (Test-Path -Path $assemblyPath)) {
            throw "Required assembly not found: '$assemblyPath'. Please run the build/publish step (e.g., 'dotnet publish') before importing this module."
        }
        Import-Module $assemblyPath
    }
    default {
        @()
    }
}

# Get public and private function definition files and dot source them
$Public = @(Get-ChildItem -Path ("$PSScriptRoot{0}Src{0}Public{0}*.ps1" -f [System.IO.Path]::DirectorySeparatorChar) -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path ("$PSScriptRoot{0}Src{0}Private{0}*.ps1" -f [System.IO.Path]::DirectorySeparatorChar) -ErrorAction SilentlyContinue)

foreach ($Module in @($Public + $Private)) {
    try {
        . $Module.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Module.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
Export-ModuleMember -Function $Private.BaseName