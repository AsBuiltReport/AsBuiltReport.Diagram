BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-InvertedLShapeLine.ps1')
}

Describe Add-InvertedLShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-InvertedLShapeLine
        [string]$DotOutPutDebug = Add-InvertedLShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-InvertedLShapeLine -InvertedLShapeUp 'Up' -InvertedLShapeDown 'Down' -InvertedLShapeRight 'Right'
        [string]$DotOutPutWithParamsArrowsTest = Add-InvertedLShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-InvertedLShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-InvertedLShapeLine -InvertedLShapeUpLineLength 3 -InvertedLShapeRightLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-InvertedLShapeLine -InvertedLShapeUp 'Up' -InvertedLShapeDown 'Down' -InvertedLShapeRight 'Right' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -InvertedLShapeUpLineLength 3 -InvertedLShapeRightLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-InvertedLShapeLine -InvertedLShapeUp 'Up' -InvertedLShapeDown 'Down' -InvertedLShapeRight 'Right' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -InvertedLShapeUpLineLength 3 -InvertedLShapeRightLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming an inverted L-shape line' {
        $DotOutPut | Should -Match '"InvertedLShapeUp"'
        $DotOutPut | Should -Match '"InvertedLShapeDown"'
        $DotOutPut | Should -Match '"InvertedLShapeRight"'
        $DotOutPut | Should -Match '"InvertedLShapeUp"->"InvertedLShapeDown"'
        $DotOutPut | Should -Match '"InvertedLShapeUp"->"InvertedLShapeRight"'
    }
    It 'Should return a Graphviz dot source with nodes forming an inverted L-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming an inverted L-shape line' {
        $DotOutPutWithParams | Should -Match '"Up"'
        $DotOutPutWithParams | Should -Match '"Down"'
        $DotOutPutWithParams | Should -Match '"Right"'
        $DotOutPutWithParams | Should -Match '"Up"->"Down"'
        $DotOutPutWithParams | Should -Match '"Up"->"Right"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-InvertedLShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-InvertedLShapeLine @DotOutPutWithParamsLineTestError }
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
