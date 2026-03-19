BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-LeftTShapeLine.ps1')
}

Describe Add-LeftTShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-LeftTShapeLine
        [string]$DotOutPutDebug = Add-LeftTShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-LeftTShapeLine -LeftTShapeUp 'Up' -LeftTShapeDown 'Down' -LeftTShapeMiddleRight 'MiddleRight' -LeftTShapeMiddleLeft 'MiddleLeft'
        [string]$DotOutPutWithParamsArrowsTest = Add-LeftTShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-LeftTShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-LeftTShapeLine -LeftTShapeUpLineLength 3 -LeftTShapeDownLineLength 3 -LeftTShapeMiddleLeftLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-LeftTShapeLine -LeftTShapeUp 'Up' -LeftTShapeDown 'Down' -LeftTShapeMiddleRight 'MiddleRight' -LeftTShapeMiddleLeft 'MiddleLeft' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LeftTShapeUpLineLength 3 -LeftTShapeDownLineLength 3 -LeftTShapeMiddleLeftLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-LeftTShapeLine -LeftTShapeUp 'Up' -LeftTShapeDown 'Down' -LeftTShapeMiddleRight 'MiddleRight' -LeftTShapeMiddleLeft 'MiddleLeft' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LeftTShapeUpLineLength 3 -LeftTShapeDownLineLength 3 -LeftTShapeMiddleLeftLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming a left T-shape line' {
        $DotOutPut | Should -Match '"LeftTShapeUp"'
        $DotOutPut | Should -Match '"LeftTShapeDown"'
        $DotOutPut | Should -Match '"LeftTShapeMiddleRight"'
        $DotOutPut | Should -Match '"LeftTShapeMiddleLeft"'
        $DotOutPut | Should -Match '"LeftTShapeUp"->"LeftTShapeMiddleRight"'
        $DotOutPut | Should -Match '"LeftTShapeMiddleRight"->"LeftTShapeDown"'
        $DotOutPut | Should -Match '"LeftTShapeMiddleLeft"->"LeftTShapeMiddleRight"'
    }
    It 'Should return a Graphviz dot source with nodes forming a left T-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming a left T-shape line' {
        $DotOutPutWithParams | Should -Match '"Up"'
        $DotOutPutWithParams | Should -Match '"Down"'
        $DotOutPutWithParams | Should -Match '"MiddleRight"'
        $DotOutPutWithParams | Should -Match '"MiddleLeft"'
        $DotOutPutWithParams | Should -Match '"Up"->"MiddleRight"'
        $DotOutPutWithParams | Should -Match '"MiddleRight"->"Down"'
        $DotOutPutWithParams | Should -Match '"MiddleLeft"->"MiddleRight"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-LeftTShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-LeftTShapeLine @DotOutPutWithParamsLineTestError }
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
