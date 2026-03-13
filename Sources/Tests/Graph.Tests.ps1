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
}

Describe Graph {
    BeforeAll {
        [string]$SimpleGraph = Graph g {
            Node 'Server1'
        }

        [string]$NamedGraph = Graph -Name 'myGraph' -ScriptBlock {
            Node 'Server1'
        }

        [string]$GraphWithAttributes = Graph -Name 'attrGraph' -Attributes @{ rankdir = 'LR' } -ScriptBlock {
            Node 'Server1'
        }
    }

    It 'Should return a string' {
        $SimpleGraph | Should -BeOfType String
    }

    It 'Should generate valid DOT digraph syntax' {
        $SimpleGraph | Should -Match 'digraph\s+g\s*\{'
    }

    It 'Should contain a closing brace' {
        $SimpleGraph | Should -Match '\}'
    }

    It 'Should support a custom graph name' {
        $NamedGraph | Should -Match 'digraph\s+myGraph\s*\{'
    }

    It 'Should include graph attributes in the DOT output' {
        $GraphWithAttributes | Should -Match 'rankdir="LR"'
    }

    It 'Should include compound attribute by default' {
        $SimpleGraph | Should -Match 'compound="true"'
    }

    It 'Should be callable via DiGraph alias' {
        [string]$AliasGraph = DiGraph aliasTest {
            Node 'Server1'
        }
        $AliasGraph | Should -Match 'digraph\s+aliasTest\s*\{'
    }
}
