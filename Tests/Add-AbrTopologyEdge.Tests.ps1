BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe Add-AbrTopologyEdge {
    BeforeAll {
        $Diagram = New-AbrTopologyDiagram -Id 'UnitTest'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'App01' -Label 'App-Server-01'
        $Diagram = $Diagram | Add-AbrTopologyEdge -Id 'WebApp' -SourceId 'Web01' -TargetId 'App01' -Label 'HTTPS' -Kind DataFlow
    }

    It 'Should return a ChartForgeX.Topology.TopologyChart object' {
        $Diagram | Should -BeOfType [ChartForgeX.Topology.TopologyChart]
    }

    It 'Should add the edge to the diagram' {
        ($Diagram.Edges | Where-Object { $_.Id -eq 'WebApp' }).Label | Should -BeExactly 'HTTPS'
    }

    It 'Should link the correct source and target node ids' {
        $Edge = $Diagram.Edges | Where-Object { $_.Id -eq 'WebApp' }
        $Edge.SourceNodeId | Should -BeExactly 'Web01'
        $Edge.TargetNodeId | Should -BeExactly 'App01'
    }

    It 'Should set the edge Kind' {
        ($Diagram.Edges | Where-Object { $_.Id -eq 'WebApp' }).Kind | Should -Be ([ChartForgeX.Topology.TopologyEdgeKind]::DataFlow)
    }

    It 'Should set the edge line emphasis' {
        $EmphasizedDiagram = New-AbrTopologyDiagram -Id 'EmphasisTest'
        $EmphasizedDiagram = $EmphasizedDiagram | Add-AbrTopologyNode -Id 'Source' -Label 'Source'
        $EmphasizedDiagram = $EmphasizedDiagram | Add-AbrTopologyNode -Id 'Target' -Label 'Target'
        $EmphasizedDiagram = $EmphasizedDiagram | Add-AbrTopologyEdge -Id 'StrongEdge' -SourceId 'Source' -TargetId 'Target' -Emphasis Strong

        ($EmphasizedDiagram.Edges | Where-Object { $_.Id -eq 'StrongEdge' }).Emphasis | Should -Be ([ChartForgeX.Topology.TopologyEdgeEmphasis]::Strong)
    }

    It 'Should set edge endpoint, stroke, and layout features' {
        $FeatureDiagram = New-AbrTopologyDiagram -Id 'EdgeFeatureTest'
        $FeatureDiagram = $FeatureDiagram | Add-AbrTopologyNode -Id 'Source' -Label 'Source'
        $FeatureDiagram = $FeatureDiagram | Add-AbrTopologyNode -Id 'Target' -Label 'Target'
        $FeatureDiagram = $FeatureDiagram | Add-AbrTopologyNodePort -NodeId 'Source' -Id 'eth0' -Side Right
        $FeatureDiagram = $FeatureDiagram | Add-AbrTopologyNodePort -NodeId 'Target' -Id 'eth1' -Side Left
        $FeatureDiagram = $FeatureDiagram | Add-AbrTopologyEdge -Id 'FeatureEdge' -SourceId 'Source' -TargetId 'Target' `
            -SourcePortId 'eth0' -TargetPortId 'eth1' -SourceMarker Circle -TargetMarker Diamond -StrokeWidth 3 -Opacity 0.5 -DashPattern @(8, 4) `
            -SourceLabel 'eth0' -TargetLabel 'eth1' -PreferredLength 240 -MinimumRankSpan 2 -RoutingPriority 5

        $Edge = $FeatureDiagram.Edges | Where-Object { $_.Id -eq 'FeatureEdge' }
        $Edge.SourcePortId | Should -BeExactly 'eth0'
        $Edge.TargetPortId | Should -BeExactly 'eth1'
        $Edge.SourceMarker | Should -Be ([ChartForgeX.Topology.TopologyMarkerKind]::Circle)
        $Edge.TargetMarker | Should -Be ([ChartForgeX.Topology.TopologyMarkerKind]::Diamond)
        $Edge.StrokeWidth | Should -Be 3
        $Edge.Opacity | Should -Be 0.5
        $Edge.DashPattern | Should -Be @(8, 4)
        $Edge.SourceLabel | Should -BeExactly 'eth0'
        $Edge.TargetLabel | Should -BeExactly 'eth1'
        $Edge.PreferredLength | Should -Be 240
        $Edge.MinimumRankSpan | Should -Be 2
        $Edge.RoutingPriority | Should -Be 5
    }
}
