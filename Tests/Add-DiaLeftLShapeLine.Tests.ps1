BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-DiaLeftLShapeLine.ps1')
}

Describe Add-DiaLeftLShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-DiaLeftLShapeLine
        [string]$DotOutPutDebug = Add-DiaLeftLShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-DiaLeftLShapeLine -LeftLShapeUp 'Up' -LeftLShapeDown 'Down' -LeftLShapeLeft 'Left'
        [string]$DotOutPutWithParamsArrowsTest = Add-DiaLeftLShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-DiaLeftLShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-DiaLeftLShapeLine -LeftLShapeUpLineLength 3 -LeftLShapeLeftLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-DiaLeftLShapeLine -LeftLShapeUp 'Up' -LeftLShapeDown 'Down' -LeftLShapeLeft 'Left' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LeftLShapeUpLineLength 3 -LeftLShapeLeftLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-DiaLeftLShapeLine -LeftLShapeUp 'Up' -LeftLShapeDown 'Down' -LeftLShapeLeft 'Left' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LeftLShapeUpLineLength 3 -LeftLShapeLeftLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming a left L-shape line' {
        $DotOutPut | Should -Match '"LeftLShapeUp"'
        $DotOutPut | Should -Match '"LeftLShapeDown"'
        $DotOutPut | Should -Match '"LeftLShapeLeft"'
        $DotOutPut | Should -Match '"LeftLShapeUp"->"LeftLShapeDown"'
        $DotOutPut | Should -Match '"LeftLShapeLeft"->"LeftLShapeUp"'
    }
    It 'Should return a Graphviz dot source with nodes forming a left L-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming a left L-shape line' {
        $DotOutPutWithParams | Should -Match '"Up"'
        $DotOutPutWithParams | Should -Match '"Down"'
        $DotOutPutWithParams | Should -Match '"Left"'
        $DotOutPutWithParams | Should -Match '"Up"->"Down"'
        $DotOutPutWithParams | Should -Match '"Left"->"Up"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-DiaLeftLShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-DiaLeftLShapeLine @DotOutPutWithParamsLineTestError }
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
