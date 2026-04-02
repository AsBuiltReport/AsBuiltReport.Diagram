BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-CrossShapeLine.ps1')
}

Describe Add-CrossShapeLine {
    BeforeAll {
        [string]$DotOutPut = Add-CrossShapeLine
        [string]$DotOutPutDebug = Add-CrossShapeLine -DraftMode $true
        [string]$DotOutPutWithParams = Add-CrossShapeLine -CrossShapeStart 'Start' -CrossShapeEnd 'End' -CrossShapeMiddle 'Middle' -CrossShapeMiddleTop 'Top' -CrossShapeMiddleDown 'Down'
        [string]$DotOutPutWithParamsArrowsTest = Add-CrossShapeLine -Arrowtail box -Arrowhead diamond
        [string]$DotOutPutWithParamsLineTest = Add-CrossShapeLine -LineStyle solid -LineWidth 3 -LineColor red
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
        [string]$DotOutPutWithParamsLineLengthTest = Add-CrossShapeLine -CrossShapeStartLineLength 3 -CrossShapeEndLineLength 3 -CrossShapeMiddleTopLineLength 3 -CrossShapeMiddleDownLineLength 3
        [string]$DotOutPutWithAllParamsTest = Add-CrossShapeLine -CrossShapeStart 'Start' -CrossShapeEnd 'End' -CrossShapeMiddle 'Middle' -CrossShapeMiddleTop 'Top' -CrossShapeMiddleDown 'Down' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -CrossShapeStartLineLength 3 -CrossShapeEndLineLength 3 -CrossShapeMiddleTopLineLength 3 -CrossShapeMiddleDownLineLength 3
        [string]$DotOutPutWithAllParamsDebugTest = Add-CrossShapeLine -CrossShapeStart 'Start' -CrossShapeEnd 'End' -CrossShapeMiddle 'Middle' -CrossShapeMiddleTop 'Top' -CrossShapeMiddleDown 'Down' -Arrowtail box -Arrowhead diamond -LineStyle solid -LineWidth 3 -LineColor red -CrossShapeStartLineLength 3 -CrossShapeEndLineLength 3 -CrossShapeMiddleTopLineLength 3 -CrossShapeMiddleDownLineLength 3 -DraftMode $true
    }

    It 'Should return a Graphviz dot source with nodes forming a cross shape line' {
        $DotOutPut | Should -Match '"CrossShapeStart"'
        $DotOutPut | Should -Match '"CrossShapeEnd"'
        $DotOutPut | Should -Match '"CrossShapeMiddle"'
        $DotOutPut | Should -Match '"CrossShapeMiddleTop"'
        $DotOutPut | Should -Match '"CrossShapeMiddleDown"'
        $DotOutPut | Should -Match '"CrossShapeStart"->"CrossShapeMiddle"'
        $DotOutPut | Should -Match '"CrossShapeMiddle"->"CrossShapeEnd"'
        $DotOutPut | Should -Match '"CrossShapeMiddleTop"->"CrossShapeMiddle"'
        $DotOutPut | Should -Match '"CrossShapeMiddle"->"CrossShapeMiddleDown"'
    }
    It 'Should return a Graphviz dot source with nodes forming a cross shape line with debug information' {
        $DotOutPutDebug | Should -Match 'fillcolor="red"'
    }
    It 'Should return a Graphviz dot source with custom node names forming a cross shape line' {
        $DotOutPutWithParams | Should -Match '"Start"'
        $DotOutPutWithParams | Should -Match '"End"'
        $DotOutPutWithParams | Should -Match '"Middle"'
        $DotOutPutWithParams | Should -Match '"Top"'
        $DotOutPutWithParams | Should -Match '"Down"'
        $DotOutPutWithParams | Should -Match '"Start"->"Middle"'
        $DotOutPutWithParams | Should -Match '"Middle"->"End"'
        $DotOutPutWithParams | Should -Match '"Top"->"Middle"'
        $DotOutPutWithParams | Should -Match '"Middle"->"Down"'
    }
    It 'Should return a Graphviz dot source with custom Arrowhead and Arrowtail' {
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowhead="diamond"'
        $DotOutPutWithParamsArrowsTest | Should -Match 'arrowtail="box"'
    }
    It "Should return a error: Cannot validate argument on parameter 'Arrowtail'" {
        $scriptBlock = { Add-CrossShapeLine @DotOutPutWithParamsArrowsTestError }
        $scriptBlock | Should -Throw
    }
    It 'Should return a Graphviz dot source with custom LineStyle, LineWidth and LineColor' {
        $DotOutPutWithParamsLineTest | Should -Match 'style="solid"'
        $DotOutPutWithParamsLineTest | Should -Match 'penwidth="3"'
        $DotOutPutWithParamsLineTest | Should -Match 'color="red"'
    }
    It "Should return a error: Cannot validate argument on parameter 'LineWidth'" {
        $scriptBlock = { Add-CrossShapeLine @DotOutPutWithParamsLineTestError }
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
