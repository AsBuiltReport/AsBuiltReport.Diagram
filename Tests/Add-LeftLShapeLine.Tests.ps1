BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-LeftLShapeLine.ps1')
}

Describe Add-LeftLShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-LeftLShapeLine
        [string]$DotOutPutDebug = Add-LeftLShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-LeftLShapeLine -LeftLShapeUp 'Up' -LeftLShapeDown 'Down' -LeftLShapeLeft 'Left'
        [string]$DotOutPutWithParamsArrowsTest = Add-LeftLShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-LeftLShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-LeftLShapeLine -LeftLShapeUpLineLength 3 -LeftLShapeLeftLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-LeftLShapeLine -LeftLShapeUp 'Up' -LeftLShapeDown 'Down' -LeftLShapeLeft 'Left' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LeftLShapeUpLineLength 3 -LeftLShapeLeftLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-LeftLShapeLine -LeftLShapeUp 'Up' -LeftLShapeDown 'Down' -LeftLShapeLeft 'Left' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -LeftLShapeUpLineLength 3 -LeftLShapeLeftLineLength 3 -DraftMode $true
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
        $scriptBlock = { Add-LeftLShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-LeftLShapeLine @DotOutPutWithParamsLineTestError }
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
