$Script:ModuleName = 'Diagrammer.Core.psd1'
$Script:TestsFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:ProjectRoot = Split-Path -Parent $TestsFolder
$Script:ModuleRoot = Join-Path -Path $ProjectRoot -ChildPath $ModuleName
$Script:ModuleManifestPath = Join-Path -Path $Script:ModuleRoot -ChildPath ('{0}.psd1' -f $Script:ModuleName)
$Script:PrivateFolder = Join-Path -Path $ProjectRoot -ChildPath ('Src{0}Private' -f [System.IO.Path]::DirectorySeparatorChar)
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

if (-not (Get-Module $ModuleName)) {
    Import-Module $ModuleRoot -Force
}

$assemblyName = switch ($PSVersionTable.PSEdition) {
    'Core' {
        @(Get-ChildItem -Path ("$ProjectRoot{0}Src{0}Bin{0}Assemblies{0}net90{0}*.dll" -f [System.IO.Path]::DirectorySeparatorChar) -ErrorAction SilentlyContinue)
    }
    'Desktop' {
        @(Get-ChildItem -Path ("$ProjectRoot{0}Src{0}Bin{0}Assemblies{0}net48{0}*.dll" -f [System.IO.Path]::DirectorySeparatorChar) -ErrorAction SilentlyContinue)
    }
    default {
        @()
    }
}

$loadedassemblies = [System.AppDomain]::CurrentDomain.GetAssemblies().ManifestModule.Name

foreach ($Assembly in $assemblyName) {
    if ($Assembly.Name -notin $loadedassemblies) {
        try {
            Write-Verbose -Message "Loading assembly '$($Assembly.Name)'."
            Add-Type -Path $Assembly.FullName -Verbose
        } catch {
            Write-Error -Message "Failed to add assembly $($Assembly.FullName): $_"
        }
    }
}