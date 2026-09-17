BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe Add-AbrTopologyNode {
    BeforeAll {
        $Diagram = New-AbrTopologyDiagram -Id 'UnitTest'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -Kind Server -Status Healthy
        $IconPath = Join-Path -Path $ProjectRoot -ChildPath ('AsBuiltReport.Diagram{0}Tools{0}Icons{0}AsBuiltReport.png' -f [System.IO.Path]::DirectorySeparatorChar)
    }

    Context 'Basic node creation' {
        It 'Should return a ChartForgeX.Topology.TopologyChart object' {
            $Diagram | Should -BeOfType [ChartForgeX.Topology.TopologyChart]
        }

        It 'Should add the node to the diagram' {
            ($Diagram.Nodes | Where-Object { $_.Id -eq 'Web01' }).Label | Should -BeExactly 'Web-Server-01'
        }

        It 'Should set the node Kind' {
            ($Diagram.Nodes | Where-Object { $_.Id -eq 'Web01' }).Kind | Should -Be ([ChartForgeX.Topology.TopologyNodeKind]::Server)
        }

        It 'Should set the node Status' {
            ($Diagram.Nodes | Where-Object { $_.Id -eq 'Web01' }).Status | Should -Be ([ChartForgeX.Topology.TopologyHealthStatus]::Healthy)
        }
    }

    Context 'Custom icon support' {
        It 'Should accept an -IconPath and embed it as a base64 data URI' {
            $DiagramWithIcon = New-AbrTopologyDiagram -Id 'UnitTest' | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -IconPath $IconPath
            $Node = $DiagramWithIcon.Nodes | Where-Object { $_.Id -eq 'Web01' }
            $Node.Artwork | Should -Not -BeNullOrEmpty
        }

        It 'Should default to a DisplayMode that keeps the label visible alongside the icon' {
            $DiagramWithIcon = New-AbrTopologyDiagram -Id 'UnitTest' | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -IconPath $IconPath
            $Node = $DiagramWithIcon.Nodes | Where-Object { $_.Id -eq 'Web01' }
            # Regression test: ChartForgeX's 'Artwork' display mode renders only the icon image with no
            # visible label text. The default must be 'Card' (or another mode that shows both icon+label).
            $Node.DisplayMode | Should -Not -Be ([ChartForgeX.Topology.TopologyNodeDisplayMode]::Artwork)
        }

        It 'Should render the node label as visible text in the exported SVG when using -IconPath' {
            $DiagramWithIcon = New-AbrTopologyDiagram -Id 'UnitTest' | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -IconPath $IconPath
            $Svg = $DiagramWithIcon | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'IconLabelTest' -Format svg
            $Content = Get-Content -Path $Svg.FullName -Raw
            $Content | Should -Match 'Web-Server-01'
        }
    }

    Context 'Invalid input' {
        It 'Should throw when -IconPath does not exist' {
            { New-AbrTopologyDiagram -Id 'UnitTest' | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -IconPath 'C:\DoesNotExist.png' } | Should -Throw
        }
    }
}
