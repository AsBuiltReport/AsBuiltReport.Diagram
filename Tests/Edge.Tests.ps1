BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    $PSGraphFolder = Join-Path -Path $PrivateFolder -ChildPath 'PSGraph'
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Get-Indent.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Format-KeyName.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Set-NodeFormatScript.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Format-Value.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'ConvertTo-GraphVizAttribute.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Edge.ps1')
}

Describe Edge {
    BeforeAll {
        $Script:indent = 0
        $Script:SubGraphList = @{}
        [string]$SimpleEdge = Edge -From 'NodeA' -To 'NodeB'
        [string]$EdgeWithAttributes = Edge -From 'NodeA' -To 'NodeB' -Attributes @{ label = 'Link'; color = 'red' }
        [string]$ChainedEdge = Edge -From 'Node1', 'Node2', 'Node3'
        [string]$DefaultAttrsEdge = Edge @{ style = 'dashed' }
    }

    It 'Should return a string' {
        $SimpleEdge | Should -BeOfType String
    }

    It 'Should generate valid DOT edge syntax with arrow' {
        $SimpleEdge | Should -Match '"NodeA"->"NodeB"'
    }

    It 'Should include attributes when provided' {
        $EdgeWithAttributes | Should -Match 'label="Link"'
        $EdgeWithAttributes | Should -Match 'color="red"'
    }

    It 'Should generate sequential edges for an array of nodes' {
        $ChainedEdge | Should -Match '"Node1"->"Node2"'
        $ChainedEdge | Should -Match '"Node2"->"Node3"'
    }

    It 'Should support setting default edge attributes via hashtable' {
        $DefaultAttrsEdge | Should -Match 'edge\s+\[style="dashed";'
    }

    It 'Should cross-multiply when two arrays are provided' {
        $Script:indent = 0
        $Script:SubGraphList = @{}
        [string]$CrossEdge = Edge -From 'A', 'B' -To 'C', 'D'
        $CrossEdge | Should -Match '"A"->"C"'
        $CrossEdge | Should -Match '"A"->"D"'
        $CrossEdge | Should -Match '"B"->"C"'
        $CrossEdge | Should -Match '"B"->"D"'
    }
}
