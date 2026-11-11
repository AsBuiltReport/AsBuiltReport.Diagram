BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe New-AbrDiagram {
    It 'Should include Graphviz and font details in draft-mode output' {
        $InputObject = & {
            Node -Name 'DraftNode' -Attributes @{ label = 'Draft node' }
        }

        New-AbrDiagram -InputObject $InputObject -OutputFolderPath $TestDrive -Format dot -Filename 'DraftMetadata' `
            -MainDiagramLabel 'Draft metadata' -DraftMode -Fontname 'Arial' -Fontcolor '#112233' `
            -NodeFontSize 18 -NodeFontcolor '#445566' -MainDiagramLabelFontname 'Courier New' `
            -MainDiagramLabelFontsize 20 -MainDiagramLabelFontColor '#778899' -MainDiagramLabelFontItalic

        $DotOutput = Get-Content -Path (Join-Path -Path $TestDrive -ChildPath 'DraftMetadata.dot') -Raw

        $DotOutput | Should -Match 'Graphviz version: [\w.]+'
        $DotOutput | Should -Match 'Graph font: Size=32; Color=#112233; Family=Arial; Style=Regular'
        $DotOutput | Should -Match 'Node font: Size=18; Color=#445566; Family=Arial; Style=Regular'
        $DotOutput | Should -Match 'Title font: Size=20; Color=#778899; Family=Courier New; Style=Italic'
    }
}
