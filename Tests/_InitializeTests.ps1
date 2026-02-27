$Script:ModuleName = 'Diagrammer.Core.psd1'
$Script:TestsFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:ProjectRoot = Split-Path -Parent $TestsFolder
$Script:ModuleRoot = Join-Path -Path $ProjectRoot -ChildPath $ModuleName
$Script:ModuleManifestPath = Join-Path -Path $Script:ModuleRoot -ChildPath ('{0}.psd1' -f $Script:ModuleName)
$Script:PrivateFolder = Join-Path -Path $ProjectRoot -ChildPath ('Src{0}Private' -f [System.IO.Path]::DirectorySeparatorChar)
$Script:PublicFolder = Join-Path -Path $ProjectRoot -ChildPath ('Src{0}Public' -f [System.IO.Path]::DirectorySeparatorChar)
$Script:GraphvizPath = switch ($PSVersionTable.Platform) {
    'Unix' {
        & {
            if (Test-Path -Path '/usr/bin/dot') {
                '/usr/bin/dot'
            } elseif (Test-Path -Path '/bin/dot') {
                '/bin/dot'
            } elseif (Test-Path -Path '/usr/local/bin/dot') {
                '/usr/local/bin/dot'
            } elseif (Test-Path -Path '/opt/homebrew/bin/dot') {
                '/opt/homebrew/bin/dot'
            } else {
                throw "Graphviz 'dot' executable not found in standard Unix paths. Please install Graphviz."
            }
        }
    }
    default { Join-Path -Path $ProjectRoot -ChildPath 'Tools\Graphviz\bin\dot.exe' }
}

switch ($PSVersionTable.PSEdition) {
    'Core' {
        Import-Module ("$ProjectRoot{0}Src{0}Bin{0}Assemblies{0}net80{0}Diagrammer.dll" -f [System.IO.Path]::DirectorySeparatorChar)
    }
    'Desktop' {
        Import-Module ("$ProjectRoot{0}Src{0}Bin{0}Assemblies{0}net48{0}DiaConvertImageToPDF.dll" -f [System.IO.Path]::DirectorySeparatorChar)
    }
    default {
        @()
    }
}

if (-not (Get-Module $ModuleName)) {
    Import-Module $ModuleRoot -Force
}