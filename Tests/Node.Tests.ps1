BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    $PSGraphFolder = Join-Path -Path $PrivateFolder -ChildPath 'PSGraph'
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Get-Indent.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Format-KeyName.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Set-NodeFormatScript.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Format-Value.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'ConvertTo-GraphVizAttribute.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Rank.ps1')
    . (Join-Path -Path $PSGraphFolder -ChildPath 'Node.ps1')
}

Describe Node {
    BeforeAll {
        $Script:indent = 0
        [string]$SimpleNode = Node -Name 'Server1'
        [string]$NodeWithAttributes = Node -Name 'Server1' -Attributes @{ shape = 'box'; color = 'blue' }
        [string]$DefaultAttrsNode = Node @{ shape = 'rectangle' }
    }

    It 'Should return a string' {
        $SimpleNode | Should -BeOfType String
    }

    It 'Should generate valid DOT node syntax' {
        $SimpleNode | Should -Match '"Server1"'
    }

    It 'Should include attributes when provided' {
        $NodeWithAttributes | Should -Match 'shape="box"'
        $NodeWithAttributes | Should -Match 'color="blue"'
    }

    It 'Should support setting default node attributes via hashtable' {
        $DefaultAttrsNode | Should -Match 'node\s+\[shape="rectangle";'
    }

    It 'Should handle multiple nodes in an array' {
        $Script:indent = 0
        [string]$MultiNode1 = Node -Name 'NodeA'
        [string]$MultiNode2 = Node -Name 'NodeB'
        $MultiNode1 | Should -Match '"NodeA"'
        $MultiNode2 | Should -Match '"NodeB"'
    }
}
