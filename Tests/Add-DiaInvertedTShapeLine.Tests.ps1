BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-DiaInvertedTShapeLine.ps1')
}

Describe Add-DiaInvertedTShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-DiaInvertedTShapeLine
        [string]$DotOutPutDebug = Add-DiaInvertedTShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-DiaInvertedTShapeLine -InvertedTStart 'Start' -InvertedTEnd 'End' -InvertedTMiddleTop 'MiddleTop' -InvertedTMiddleDown 'MiddleDown'
        [string]$DotOutPutWithParamsArrowsTest = Add-DiaInvertedTShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-DiaInvertedTShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-DiaInvertedTShapeLine -InvertedTStartLineLength 3 -InvertedTEndLineLength 3 -InvertedTMiddleTopLength 3
        [string]$DotOutPutWithAllParamsTest = Add-DiaInvertedTShapeLine -InvertedTStart 'Start' -InvertedTEnd 'End' -InvertedTMiddleTop 'MiddleTop' -InvertedTMiddleDown 'MiddleDown' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -InvertedTStartLineLength 3 -InvertedTEndLineLength 3 -InvertedTMiddleTopLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-DiaInvertedTShapeLine -InvertedTStart 'Start' -InvertedTEnd 'End' -InvertedTMiddleTop 'MiddleTop' -InvertedTMiddleDown 'MiddleDown' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -InvertedTStartLineLength 3 -InvertedTEndLineLength 3 -InvertedTMiddleTopLength 3 -DraftMode $true
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
        $scriptBlock = { Add-DiaInvertedTShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-DiaInvertedTShapeLine @DotOutPutWithParamsLineTestError }
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
