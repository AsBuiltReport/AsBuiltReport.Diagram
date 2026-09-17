BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe ChartForgeXExample03 {
    BeforeAll {
        $RunFile = & $ProjectRoot/Examples/ChartForgeXExample03.ps1 -Path $TestDrive -Format svg
        $Script:SvgContent = Get-Content -Path $RunFile.FullName -Raw
    }

    It 'renders the Example15 web application hierarchy' {
        $SvgContent | Should -Match 'Web Application Diagram'
        $SvgContent | Should -Match 'Web-Server-01'
        $SvgContent | Should -Match 'App-Server-01'
        $SvgContent | Should -Match 'Db-Server-01'
        $SvgContent | Should -Match 'Core-Router'
        $SvgContent | Should -Match 'Firewall'
        $SvgContent | Should -Match 'WAN'
    }

    It 'renders hierarchy relationships' {
        $SvgContent | Should -Match 'data-cfx-meta-hierarchy-relationship="parent-child"'
    }
}
