BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-DiaRightTShapeLine.ps1')
}

Describe Add-DiaRightTShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-DiaRightTShapeLine
        [string]$DotOutPutDebug = Add-DiaRightTShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-DiaRightTShapeLine -RightTShapeUp 'Up' -RightTShapeDown 'Down' -RightTShapeMiddleRight 'MiddleRight' -RightTShapeMiddleLeft 'MiddleLeft'
        [string]$DotOutPutWithParamsArrowsTest = Add-DiaRightTShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-DiaRightTShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-DiaRightTShapeLine -RightTShapeUpLineLength 3 -RightTShapeDownLineLength 3 -RightTShapeMiddleRightLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-DiaRightTShapeLine -RightTShapeUp 'Up' -RightTShapeDown 'Down' -RightTShapeMiddleRight 'MiddleRight' -RightTShapeMiddleLeft 'MiddleLeft' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -RightTShapeUpLineLength 3 -RightTShapeDownLineLength 3 -RightTShapeMiddleRightLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-DiaRightTShapeLine -RightTShapeUp 'Up' -RightTShapeDown 'Down' -RightTShapeMiddleRight 'MiddleRight' -RightTShapeMiddleLeft 'MiddleLeft' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -RightTShapeUpLineLength 3 -RightTShapeDownLineLength 3 -RightTShapeMiddleRightLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming a right T-shape line' {
        $DotOutPut | Should -Match '"RightTShapeUp"'
        $DotOutPut | Should -Match '"RightTShapeDown"'
        $DotOutPut | Should -Match '"RightTShapeMiddleRight"'
        $DotOutPut | Should -Match '"RightTShapeMiddleLeft"'
        $DotOutPut | Should -Match '"RightTShapeUp"->"RightTShapeMiddleLeft"'
        $DotOutPut | Should -Match '"RightTShapeMiddleLeft"->"RightTShapeDown"'
        $DotOutPut | Should -Match '"RightTShapeMiddleLeft"->"RightTShapeMiddleRight"'
    }
    It 'Should return a Graphviz dot source with nodes forming a right T-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming a right T-shape line' {
        $DotOutPutWithParams | Should -Match '"Up"'
        $DotOutPutWithParams | Should -Match '"Down"'
        $DotOutPutWithParams | Should -Match '"MiddleRight"'
        $DotOutPutWithParams | Should -Match '"MiddleLeft"'
        $DotOutPutWithParams | Should -Match '"Up"->"MiddleLeft"'
        $DotOutPutWithParams | Should -Match '"MiddleLeft"->"Down"'
        $DotOutPutWithParams | Should -Match '"MiddleLeft"->"MiddleRight"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-DiaRightTShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-DiaRightTShapeLine @DotOutPutWithParamsLineTestError }
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
