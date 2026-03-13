BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    $PSGraphFolder = Join-Path -Path $PrivateFolder -ChildPath 'PSGraph'
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Get-Indent.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Format-KeyName.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Set-NodeFormatScript.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Format-Value.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'ConvertTo-GraphVizAttribute.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Node.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Rank.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Graph.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'SubGraph.ps1')
}

Describe SubGraph {
    BeforeAll {
        [string]$GraphWithSubGraph = Graph g {
            SubGraph 0 {
                Node 'Server1'
            }
        }

        [string]$SubGraphWithAttributes = Graph g {
            SubGraph MyCluster -Attributes @{ label = 'DMZ' } {
                Node 'Web1'
            }
        }
    }

    It 'Should return a string from the parent graph' {
        $GraphWithSubGraph | Should -BeOfType String
    }

    It 'Should generate a cluster subgraph in DOT syntax' {
        $GraphWithSubGraph | Should -Match 'subgraph\s+cluster0\s*\{'
    }

    It 'Should contain the subgraph closing brace' {
        $GraphWithSubGraph | Should -Match '\}'
    }

    It 'Should include subgraph attributes when provided' {
        $SubGraphWithAttributes | Should -Match 'label="DMZ"'
    }

    It 'Should use a cluster prefix for the subgraph name' {
        $SubGraphWithAttributes | Should -Match 'subgraph\s+clusterMyCluster\s*\{'
    }
}
