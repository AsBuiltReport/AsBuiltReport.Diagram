BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe ChartForgeXExample01 {
    Context 'Format Parameter Tests' {
        It 'Should exist ChartForgeXExample01.svg' {
            $PassParamsSvg = @{
                Path   = $TestDrive
                Format = @('svg')
            }
            (& $ProjectRoot\Examples\ChartForgeXExample01.ps1 @PassParamsSvg).FullName | Should -Exist
        }

        It 'Should exist ChartForgeXExample01.png' {
            $PassParamsPng = @{
                Path   = $TestDrive
                Format = @('png')
            }
            (& $ProjectRoot\Examples\ChartForgeXExample01.ps1 @PassParamsPng).FullName | Should -Exist
        }

        It 'Should return error about unsupported Format' {
            $PassParamsBad = @{
                Path   = $TestDrive
                Format = @('dot')
            }
            { & $ProjectRoot\Examples\ChartForgeXExample01.ps1 @PassParamsBad } | Should -Throw
        }
    }

    Context 'Svg content Tests' {
        BeforeAll {
            $PassParamsSvg = @{
                Path   = $TestDrive
                Format = @('svg')
            }
            $RunFile = & $ProjectRoot\Examples\ChartForgeXExample01.ps1 @PassParamsSvg
            $SvgContent = Get-Content -Path ($RunFile).FullName -Raw
        }

        It 'Should match the diagram title' {
            $SvgContent | Should -Match '3 Tier Web Application Diagram'
        }

        It 'Should match Web-Server-01 node' {
            $SvgContent | Should -Match 'Web-Server-01'
        }

        It 'Should match App-Server-01 node' {
            $SvgContent | Should -Match 'App-Server-01'
        }

        It 'Should match Db-Server-01 node' {
            $SvgContent | Should -Match 'Db-Server-01'
        }

        It 'Should match the DMZ group' {
            $SvgContent | Should -Match 'DMZ'
        }
    }
}
