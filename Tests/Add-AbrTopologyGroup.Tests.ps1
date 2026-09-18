BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe Add-AbrTopologyGroup {
    BeforeAll {
        $Diagram = New-AbrTopologyDiagram -Id 'UnitTest'
        $Diagram = $Diagram | Add-AbrTopologyGroup -Id 'Dmz' -Label 'DMZ' -Status Healthy
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -GroupId 'Dmz'
    }

    It 'Should return a ChartForgeX.Topology.TopologyChart object' {
        $Diagram | Should -BeOfType [ChartForgeX.Topology.TopologyChart]
    }

    It 'Should add the group to the diagram' {
        ($Diagram.Groups | Where-Object { $_.Id -eq 'Dmz' }).Label | Should -BeExactly 'DMZ'
    }

    It 'Should assign the node to the group' {
        ($Diagram.Nodes | Where-Object { $_.Id -eq 'Web01' }).GroupId | Should -BeExactly 'Dmz'
    }
}
