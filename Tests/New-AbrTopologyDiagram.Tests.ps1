BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe New-AbrTopologyDiagram {
    Context 'Basic diagram creation' {
        It 'Should return a ChartForgeX.Topology.TopologyChart object' {
            $Diagram = New-AbrTopologyDiagram -Id 'UnitTest'
            $Diagram | Should -BeOfType [ChartForgeX.Topology.TopologyChart]
        }

        It 'Should set the diagram Id' {
            $Diagram = New-AbrTopologyDiagram -Id 'UnitTestId'
            $Diagram.Id | Should -BeExactly 'UnitTestId'
        }

        It 'Should set the diagram Title when provided' {
            $Diagram = New-AbrTopologyDiagram -Id 'UnitTest' -Title 'My Diagram'
            $Diagram.Title | Should -BeExactly 'My Diagram'
        }

        It 'Should default LayoutMode to Layered' {
            $Diagram = New-AbrTopologyDiagram -Id 'UnitTest'
            $Diagram.LayoutMode | Should -Be ([ChartForgeX.Topology.TopologyLayoutMode]::Layered)
        }

        It 'Should accept a custom LayoutDirection' {
            $Diagram = New-AbrTopologyDiagram -Id 'UnitTest' -LayoutDirection LeftToRight
            $Diagram.LayoutDirection | Should -Be ([ChartForgeX.Topology.TopologyLayoutDirection]::LeftToRight)
        }
    }
}
