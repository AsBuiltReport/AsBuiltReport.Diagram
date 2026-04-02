BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-InvertedTShapeLine.ps1')
}

Describe Add-InvertedTShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-InvertedTShapeLine
        [string]$DotOutPutDebug = Add-InvertedTShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-InvertedTShapeLine -InvertedTStart 'Start' -InvertedTEnd 'End' -InvertedTMiddleTop 'MiddleTop' -InvertedTMiddleDown 'MiddleDown'
        [string]$DotOutPutWithParamsArrowsTest = Add-InvertedTShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-InvertedTShapeLine -LineStyle solid -LineWidth 3 -LineColor red
        $DotOutPutWithParamsLineTestError = @{
            LineStyle = 'solid'
            LineWidth = 'baba'
            LineColor = 'red'
        }
        $DotOutPutWithParamsArrowsTestError = @{
            Arrowtail   = 'baba'
            Arrowhead   = 'diamond'
            ErrorAction = 'Stop'
        }
        [string]$DotOutPutWithParamsLineLengthTest = Add-InvertedTShapeLine -InvertedTStartLineLength 3 -InvertedTEndLineLength 3 -InvertedTMiddleTopLength 3
        [string]$DotOutPutWithAllParamsTest = Add-InvertedTShapeLine -InvertedTStart 'Start' -InvertedTEnd 'End' -InvertedTMiddleTop 'MiddleTop' -InvertedTMiddleDown 'MiddleDown' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -InvertedTStartLineLength 3 -InvertedTEndLineLength 3 -InvertedTMiddleTopLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-InvertedTShapeLine -InvertedTStart 'Start' -InvertedTEnd 'End' -InvertedTMiddleTop 'MiddleTop' -InvertedTMiddleDown 'MiddleDown' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -InvertedTStartLineLength 3 -InvertedTEndLineLength 3 -InvertedTMiddleTopLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming an inverted T-shape line' {
        $DotOutPut | Should -Match '"InvertedTStart"'
        $DotOutPut | Should -Match '"InvertedTEnd"'
        $DotOutPut | Should -Match '"InvertedTMiddleTop"'
        $DotOutPut | Should -Match '"InvertedTMiddleDown"'
        $DotOutPut | Should -Match '"InvertedTStart"->"InvertedTMiddleDown"'
        $DotOutPut | Should -Match '"InvertedTMiddleDown"->"InvertedTEnd"'
        $DotOutPut | Should -Match '"InvertedTMiddleTop"->"InvertedTMiddleDown"'
    }
    It 'Should return a Graphviz dot source with nodes forming an inverted T-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming an inverted T-shape line' {
        $DotOutPutWithParams | Should -Match '"Start"'
        $DotOutPutWithParams | Should -Match '"End"'
        $DotOutPutWithParams | Should -Match '"MiddleTop"'
        $DotOutPutWithParams | Should -Match '"MiddleDown"'
        $DotOutPutWithParams | Should -Match '"Start"->"MiddleDown"'
        $DotOutPutWithParams | Should -Match '"MiddleDown"->"End"'
        $DotOutPutWithParams | Should -Match '"MiddleTop"->"MiddleDown"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-InvertedTShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-InvertedTShapeLine @DotOutPutWithParamsLineTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom line lengths' {
        $DotOutPutWithParamsLineLengthTest | Should -Match 'minlen="3"'
    }
    It 'Should return a Graphviz dot source with all parameters' {
        $DotOutPutWithAllParamsTest | Should -Match 'style="solid"'
        $DotOutPutWithAllParamsTest | Should -Match 'penwidth="3"'
        $DotOutPutWithAllParamsTest | Should -Match 'color="red"'
        $DotOutPutWithAllParamsTest | Should -Match 'minlen="3"'
        $DotOutPutWithAllParamsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithAllParamsTest | Should -Match 'arrowtail="box"'
    }
    It 'Should return a Graphviz dot source with all parameters and DraftMode' {
        $DotOutPutWithAllParamsDebugTest | Should -Match 'fillcolor="red"'
    }
}
