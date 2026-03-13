BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-DiaRightLShapeLine.ps1')
}

Describe Add-DiaRightLShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-DiaRightLShapeLine
        [string]$DotOutPutDebug = Add-DiaRightLShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-DiaRightLShapeLine -RightLShapeUp 'Up' -RightLShapeDown 'Down' -RightLShapeRight 'Right'
        [string]$DotOutPutWithParamsArrowsTest = Add-DiaRightLShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-DiaRightLShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-DiaRightLShapeLine -RightLShapeUpLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-DiaRightLShapeLine -RightLShapeUp 'Up' -RightLShapeDown 'Down' -RightLShapeRight 'Right' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -RightLShapeUpLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-DiaRightLShapeLine -RightLShapeUp 'Up' -RightLShapeDown 'Down' -RightLShapeRight 'Right' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -RightLShapeUpLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming a right L-shape line' {
        $DotOutPut | Should -Match '"RightLShapeUp"'
        $DotOutPut | Should -Match '"RightLShapeDown"'
        $DotOutPut | Should -Match '"RightLShapeRight"'
        $DotOutPut | Should -Match '"RightLShapeUp"->"RightLShapeDown"'
        $DotOutPut | Should -Match '"RightLShapeUp"->"RightLShapeRight"'
    }
    It 'Should return a Graphviz dot source with nodes forming a right L-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming a right L-shape line' {
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
        $scriptBlock = { Add-DiaRightLShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-DiaRightLShapeLine @DotOutPutWithParamsLineTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom RightLShapeUpLineLength' {
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
