BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe 'New-AbrTopologyLegend, Add-AbrTopologyLegendItem, Set-AbrTopologyLegend' {
    BeforeAll {
        $Legend = New-AbrTopologyLegend -Title 'Legend'
        $Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Server' -NodeKind Server -Color '#16A34A'
        $Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Dependency' -EdgeKind Dependency -Color '#71797E'
        $Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Healthy' -Status Healthy -Color '#16A34A'

        $Diagram = New-AbrTopologyDiagram -Id 'UnitTest'
        $Diagram = $Diagram | Set-AbrTopologyLegend -Legend $Legend
    }

    It 'Should return a ChartForgeX.Topology.TopologyLegend object' {
        $Legend | Should -BeOfType [ChartForgeX.Topology.TopologyLegend]
    }

    It 'Should set the legend title' {
        $Legend.Title | Should -BeExactly 'Legend'
    }

    It 'Should contain the added Node, Edge and Status entries' {
        $Legend.Items.Count | Should -Be 3
    }

    It 'Should attach the legend to the diagram' {
        $Diagram.Legend.Title | Should -BeExactly 'Legend'
    }
}
