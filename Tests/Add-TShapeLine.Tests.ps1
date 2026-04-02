BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-TShapeLine.ps1')
}

Describe Add-TShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-TShapeLine
        [string]$DotOutPutDebug = Add-TShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-TShapeLine -TShapeLeft 'Left' -TShapeRight 'Right' -TShapeMiddleUp 'MiddleUp' -TShapeMiddleDown 'MiddleDown'
        [string]$DotOutPutWithParamsArrowsTest = Add-TShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-TShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-TShapeLine -TShapeLeftLineLength 3 -TShapeRightLineLength 3 -TShapeMiddleDownLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-TShapeLine -TShapeLeft 'Left' -TShapeRight 'Right' -TShapeMiddleUp 'MiddleUp' -TShapeMiddleDown 'MiddleDown' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -TShapeLeftLineLength 3 -TShapeRightLineLength 3 -TShapeMiddleDownLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-TShapeLine -TShapeLeft 'Left' -TShapeRight 'Right' -TShapeMiddleUp 'MiddleUp' -TShapeMiddleDown 'MiddleDown' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -TShapeLeftLineLength 3 -TShapeRightLineLength 3 -TShapeMiddleDownLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming a T-shape line' {
        $DotOutPut | Should -Match '"TShapeLeft"'
        $DotOutPut | Should -Match '"TShapeRight"'
        $DotOutPut | Should -Match '"TShapeMiddleUp"'
        $DotOutPut | Should -Match '"TShapeMiddleDown"'
        $DotOutPut | Should -Match '"TShapeLeft"->"TShapeMiddleUp"'
        $DotOutPut | Should -Match '"TShapeMiddleUp"->"TShapeRight"'
        $DotOutPut | Should -Match '"TShapeMiddleUp"->"TShapeMiddleDown"'
    }
    It 'Should return a Graphviz dot source with nodes forming a T-shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming a T-shape line' {
        $DotOutPutWithParams | Should -Match '"Left"'
        $DotOutPutWithParams | Should -Match '"Right"'
        $DotOutPutWithParams | Should -Match '"MiddleUp"'
        $DotOutPutWithParams | Should -Match '"MiddleDown"'
        $DotOutPutWithParams | Should -Match '"Left"->"MiddleUp"'
        $DotOutPutWithParams | Should -Match '"MiddleUp"->"Right"'
        $DotOutPutWithParams | Should -Match '"MiddleUp"->"MiddleDown"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-TShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-TShapeLine @DotOutPutWithParamsLineTestError }
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
