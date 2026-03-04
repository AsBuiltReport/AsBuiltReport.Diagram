BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-DiaLShapeLine.ps1')
}

Describe Add-DiaLShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-DiaLShapeLine
        [string]$DotOutPutDebug = Add-DiaLShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-DiaLShapeLine -LShapeUp 'Up' -LShapeDown 'Down' -LShapeRight 'Right'
        [string]$DotOutPutWithParamsArrowsTest = Add-DiaLShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-DiaLShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-DiaLShapeLine -LShapeUpLineLength 3 -LShapeRightLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-DiaLShapeLine -LShapeUp 'Up' -LShapeDown 'Down' -LShapeRight 'Right' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LShapeUpLineLength 3 -LShapeRightLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-DiaLShapeLine -LShapeUp 'Up' -LShapeDown 'Down' -LShapeRight 'Right' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LShapeUpLineLength 3 -LShapeRightLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming an L-shape line' {
        $DotOutPut | Should -Match '"LShapeUp"'
        $DotOutPut | Should -Match '"LShapeDown"'
        $DotOutPut | Should -Match '"LShapeRight"'
        $DotOutPut | Should -Match '"LShapeUp"->"LShapeDown"'
        $DotOutPut | Should -Match '"LShapeDown"->"LShapeRight"'
    }
    It 'Should return a Graphviz dot source with nodes forming an L-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming an L-shape line' {
        $DotOutPutWithParams | Should -Match '"Up"'
        $DotOutPutWithParams | Should -Match '"Down"'
        $DotOutPutWithParams | Should -Match '"Right"'
        $DotOutPutWithParams | Should -Match '"Up"->"Down"'
        $DotOutPutWithParams | Should -Match '"Down"->"Right"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-DiaLShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-DiaLShapeLine @DotOutPutWithParamsLineTestError }
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
