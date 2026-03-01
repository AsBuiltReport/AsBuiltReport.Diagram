BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-DiaNodeEdge.ps1')
}

Describe Add-DiaNodeEdge {
    BeforeAll {
        [string]$DotOutPut = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB'
        [string]$DotOutPutStyle = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeStyle 'dashed'
        [string]$DotOutPutColor = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeColor '#FF0000'
        [string]$DotOutPutThickness = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeThickness 5
        [string]$DotOutPutArrowhead = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowhead 'vee'
        [string]$DotOutPutArrowtail = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowtail 'diamond'
        [string]$DotOutPutLabel = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabel 'MyLabel'
        [string]$DotOutPutLabelFontSize = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabel 'MyLabel' -EdgeLabelFontSize 20
        [string]$DotOutPutLabelFontColor = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabel 'MyLabel' -EdgeLabelFontColor 'blue'
        [string]$DotOutPutTailPort = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -TailPort 'e'
        [string]$DotOutPutHeadPort = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadPort 'w'
        [string]$DotOutPutAllParams = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeStyle 'dashed' -EdgeColor '#FF0000' -EdgeThickness 3 -Arrowhead 'vee' -Arrowtail 'diamond' -EdgeLabel 'Link' -EdgeLabelFontSize 14 -EdgeLabelFontColor 'blue' -TailPort 'e' -HeadPort 'w'

        # HTML edge label
        $HtmlLabel = '<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0"><TR><TD>Protocol: HTTPS</TD></TR><TR><TD>Port: 443</TD></TR></TABLE>'
        [string]$DotOutPutHtmlLabel = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HtmlEdgeLabel $HtmlLabel
        [string]$DotOutPutHtmlLabelPrecedence = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HtmlEdgeLabel $HtmlLabel -EdgeLabel 'Ignored'

        # HeadLabel and TailLabel
        [string]$DotOutPutHeadLabel = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0'
        [string]$DotOutPutTailLabel = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -TailLabel 'eth1'
        [string]$DotOutPutBothLabels = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0' -TailLabel 'eth1'
        [string]$DotOutPutLabelDistance = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0' -LabelDistance 3
        [string]$DotOutPutLabelAngle = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0' -LabelAngle 45
    }

    It 'Should return a Graphviz edge from NodeA to NodeB with default attributes' {
        $DotOutPut | Should -Match '"NodeA"->"NodeB" \[.*\]'
        $DotOutPut | Should -Match 'style="solid"'
        $DotOutPut | Should -Match 'color="black"'
        $DotOutPut | Should -Match 'penwidth="1"'
        $DotOutPut | Should -Match 'arrowhead="normal"'
        $DotOutPut | Should -Match 'arrowtail="none"'
        $DotOutPut | Should -Match 'fontsize="12"'
        $DotOutPut | Should -Match 'fontcolor="black"'
    }

    It 'Should not include label attribute when EdgeLabel is not specified' {
        $DotOutPut | Should -Not -Match 'label='
    }

    It 'Should not include tailport attribute when TailPort is not specified' {
        $DotOutPut | Should -Not -Match 'tailport='
    }

    It 'Should not include headport attribute when HeadPort is not specified' {
        $DotOutPut | Should -Not -Match 'headport='
    }

    It 'Should not include headlabel attribute when HeadLabel is not specified' {
        $DotOutPut | Should -Not -Match 'headlabel='
    }

    It 'Should not include taillabel attribute when TailLabel is not specified' {
        $DotOutPut | Should -Not -Match 'taillabel='
    }

    It 'Should return a dashed edge style' {
        $DotOutPutStyle | Should -Match 'style="dashed"'
    }

    It 'Should return a dotted edge style' {
        [string]$DotOutPutDotted = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeStyle 'dotted'
        $DotOutPutDotted | Should -Match 'style="dotted"'
    }

    It 'Should return a bold edge style' {
        [string]$DotOutPutBold = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeStyle 'bold'
        $DotOutPutBold | Should -Match 'style="bold"'
    }

    It 'Should throw on invalid edge style' {
        $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeStyle 'invalid' }
        $scriptBlock | Should -Throw
    }

    It 'Should return the specified edge color' {
        $DotOutPutColor | Should -Match 'color="#FF0000"'
    }

    It 'Should return the specified edge thickness' {
        $DotOutPutThickness | Should -Match 'penwidth="5"'
    }

    It 'Should return a Graphviz edge with custom edge thickness range validation' {
        [string]$DotOutPutMinThickness = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeThickness 1
        [string]$DotOutPutMaxThickness = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeThickness 10
        $DotOutPutMinThickness | Should -Match 'penwidth="1"'
        $DotOutPutMaxThickness | Should -Match 'penwidth="10"'
    }

    It 'Should throw when EdgeThickness is out of range' {
        $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeThickness 0 }
        $scriptBlock | Should -Throw
        $scriptBlock2 = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeThickness 11 }
        $scriptBlock2 | Should -Throw
    }

    It 'Should return the specified arrowhead style' {
        $DotOutPutArrowhead | Should -Match 'arrowhead="vee"'
    }

    It 'Should return the specified arrowtail style' {
        $DotOutPutArrowtail | Should -Match 'arrowtail="diamond"'
    }

    It 'Should accept multiple arrowhead types' {
        [string]$DotNone = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowhead 'none'
        [string]$DotNormal = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowhead 'normal'
        [string]$DotVee = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowhead 'vee'
        [string]$DotDiamond = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowhead 'diamond'
        $DotNone | Should -Match 'arrowhead="none"'
        $DotNormal | Should -Match 'arrowhead="normal"'
        $DotVee | Should -Match 'arrowhead="vee"'
        $DotDiamond | Should -Match 'arrowhead="diamond"'
    }

    It 'Should accept multiple arrowtail types' {
        [string]$DotNone = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowtail 'none'
        [string]$DotNormal = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowtail 'normal'
        [string]$DotVee = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowtail 'vee'
        [string]$DotDiamond = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowtail 'diamond'
        $DotNone | Should -Match 'arrowtail="none"'
        $DotNormal | Should -Match 'arrowtail="normal"'
        $DotVee | Should -Match 'arrowtail="vee"'
        $DotDiamond | Should -Match 'arrowtail="diamond"'
    }

    It 'Should throw on invalid arrowhead type' {
        $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowhead 'invalid' }
        $scriptBlock | Should -Throw
    }

    It 'Should throw on invalid arrowtail type' {
        $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -Arrowtail 'invalid' }
        $scriptBlock | Should -Throw
    }

    It 'Should include label when EdgeLabel is specified' {
        $DotOutPutLabel | Should -Match 'label="MyLabel"'
    }

    It 'Should return the specified label font size' {
        $DotOutPutLabelFontSize | Should -Match 'fontsize="20"'
    }

    It 'Should return a Graphviz edge with custom label font size range validation' {
        [string]$DotOutPutMinFontSize = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabelFontSize 8
        [string]$DotOutPutMaxFontSize = Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabelFontSize 72
        $DotOutPutMinFontSize | Should -Match 'fontsize="8"'
        $DotOutPutMaxFontSize | Should -Match 'fontsize="72"'
    }

    It 'Should throw when EdgeLabelFontSize is out of range' {
        $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabelFontSize 7 }
        $scriptBlock | Should -Throw
        $scriptBlock2 = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabelFontSize 73 }
        $scriptBlock2 | Should -Throw
    }

    It 'Should return the specified label font color' {
        $DotOutPutLabelFontColor | Should -Match 'fontcolor="blue"'
    }

    It 'Should include tailport when TailPort is specified' {
        $DotOutPutTailPort | Should -Match 'tailport="e"'
    }

    It 'Should include headport when HeadPort is specified' {
        $DotOutPutHeadPort | Should -Match 'headport="w"'
    }

    It 'Should return a Graphviz edge with all parameters set' {
        $DotOutPutAllParams | Should -Match '"NodeA"->"NodeB" \[.*\]'
        $DotOutPutAllParams | Should -Match 'style="dashed"'
        $DotOutPutAllParams | Should -Match 'color="#FF0000"'
        $DotOutPutAllParams | Should -Match 'penwidth="3"'
        $DotOutPutAllParams | Should -Match 'arrowhead="vee"'
        $DotOutPutAllParams | Should -Match 'arrowtail="diamond"'
        $DotOutPutAllParams | Should -Match 'label="Link"'
        $DotOutPutAllParams | Should -Match 'fontsize="14"'
        $DotOutPutAllParams | Should -Match 'fontcolor="blue"'
        $DotOutPutAllParams | Should -Match 'tailport="e"'
        $DotOutPutAllParams | Should -Match 'headport="w"'
    }

    It 'Should throw when From parameter is missing' {
        $scriptBlock = { Add-DiaNodeEdge -To 'NodeB' }
        $scriptBlock | Should -Throw
    }

    It 'Should throw when To parameter is missing' {
        $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' }
        $scriptBlock | Should -Throw
    }

    Context 'HTML edge label support' {
        It 'Should include the HTML label content when HtmlEdgeLabel is specified' {
            $DotOutPutHtmlLabel | Should -Match 'Protocol: HTTPS'
            $DotOutPutHtmlLabel | Should -Match 'Port: 443'
        }

        It 'Should use HtmlEdgeLabel over EdgeLabel when both are provided' {
            $DotOutPutHtmlLabelPrecedence | Should -Match 'Protocol: HTTPS'
            $DotOutPutHtmlLabelPrecedence | Should -Not -Match 'label="Ignored"'
        }

        It 'Should not include label attribute when neither EdgeLabel nor HtmlEdgeLabel is specified' {
            $DotOutPut | Should -Not -Match 'label='
        }
    }

    Context 'HeadLabel and TailLabel support' {
        It 'Should include headlabel when HeadLabel is specified' {
            $DotOutPutHeadLabel | Should -Match 'headlabel="eth0"'
        }

        It 'Should include taillabel when TailLabel is specified' {
            $DotOutPutTailLabel | Should -Match 'taillabel="eth1"'
        }

        It 'Should include both headlabel and taillabel when both are specified' {
            $DotOutPutBothLabels | Should -Match 'headlabel="eth0"'
            $DotOutPutBothLabels | Should -Match 'taillabel="eth1"'
        }

        It 'Should include labeldistance when HeadLabel is specified' {
            $DotOutPutHeadLabel | Should -Match 'labeldistance='
        }

        It 'Should include labelangle when HeadLabel is specified' {
            $DotOutPutHeadLabel | Should -Match 'labelangle='
        }

        It 'Should include labeldistance when TailLabel is specified' {
            $DotOutPutTailLabel | Should -Match 'labeldistance='
        }

        It 'Should include labelangle when TailLabel is specified' {
            $DotOutPutTailLabel | Should -Match 'labelangle='
        }

        It 'Should apply the specified LabelDistance' {
            $DotOutPutLabelDistance | Should -Match 'labeldistance="3"'
        }

        It 'Should apply the specified LabelAngle' {
            $DotOutPutLabelAngle | Should -Match 'labelangle="45"'
        }

        It 'Should throw when LabelDistance is out of range' {
            $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0' -LabelDistance -1 }
            $scriptBlock | Should -Throw
            $scriptBlock2 = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0' -LabelDistance 11 }
            $scriptBlock2 | Should -Throw
        }

        It 'Should throw when LabelAngle is out of range' {
            $scriptBlock = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0' -LabelAngle -181 }
            $scriptBlock | Should -Throw
            $scriptBlock2 = { Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -HeadLabel 'eth0' -LabelAngle 181 }
            $scriptBlock2 | Should -Throw
        }

        It 'Should not include labeldistance or labelangle when neither HeadLabel nor TailLabel is specified' {
            $DotOutPut | Should -Not -Match 'labeldistance='
            $DotOutPut | Should -Not -Match 'labelangle='
        }
    }
}
