<#
    This example demonstrates how to use the ShapeLine cmdlets to create geometric line connectors
    in a diagram. Each ShapeLine cmdlet creates invisible junction/routing point nodes connected
    with edges to form a specific geometric shape (L, T, Cross, etc.). Labeled endpoint nodes
    (rectangles) are attached to the junction endpoints to illustrate practical usage.
    (Part of AsBuiltReport.Diagram module)
#>

[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [array] $Format = @('png'),
    [bool] $DraftMode = $false
)

<#
    Starting with PowerShell v3, modules are auto-imported when needed. Importing the module here ensures clarity and avoids ambiguity.
#>

# Import-Module AsBuiltReport.Diagram -Force -Verbose:$false

<#
    Since the diagram output is a file, specify the output folder path using $OutputFolderPath.
#>

$OutputFolderPath = Resolve-Path -Path $Path

<#
    If the diagram uses custom icons, specify the path to the icons directory. This is a Graphviz requirement.
#>

$RootPath = $PSScriptRoot
[System.IO.FileInfo]$IconPath = Join-Path -Path $RootPath -ChildPath 'Icons'

<#
    The $Images variable is a hashtable containing the names of image files used in the diagram.
    The image files must be located in the directory specified by $IconPath.
    ** Image sizes should be around 100x100, 150x150 pixels for optimal display. **
#>

$script:Images = @{
    'Main_Logo' = 'AsBuiltReport.png'
    'Server' = 'Server.png'
    'Logo_Footer' = 'Signature_Logo.png'
}

<#
    The $MainGraphLabel variable sets the main title of the diagram.
#>

$MainGraphLabel = 'ShapeLine Cmdlets Diagram'

$example17 = & {

    <#
        Each SubGraph below demonstrates one of the available ShapeLine cmdlets.

        ShapeLine cmdlets create geometric connector patterns using invisible junction nodes.
        Visible endpoint nodes (rectangles) are connected to the junction nodes via Edge calls,
        illustrating how each shape type routes connections between diagram elements.

        The -DraftMode switch makes the invisible junction nodes visible (highlighted in red)
        to assist with layout troubleshooting.
    #>

    SubGraph LShapeGroup -Attributes @{Label = 'L-Shape Connectors'; fontsize = 20; penwidth = 2; labelloc = 't'; style = 'dashed,rounded'; color = 'darkgray' } {

        <#
            -- Add-LShapeLine
            Creates an L-shaped connector: a vertical line from top to a corner node,
            then a horizontal line from the corner to the right.

            Visual:
                        (LShapeUp)
                            o
                            |
                (LShapeDown)o___o(LShapeRight)

            Parameters:
            - LShapeUp:             Name of the top node of the vertical segment.
            - LShapeDown:           Name of the corner node where segments meet.
            - LShapeRight:          Name of the right endpoint of the horizontal segment.
            - LShapeUpLineLength:   Minimum length of the vertical segment (1-10).
            - LShapeRightLineLength:Minimum length of the horizontal segment (1-10).
            - LineStyle:            Line style (solid, dashed, dotted, bold, etc.).
            - LineWidth:            Line width/penwidth (1-10).
            - LineColor:            Line color (Graphviz color name or hex).
            - IconDebug:            Show junction nodes in red for troubleshooting.
        #>

        SubGraph LShapeDemo -Attributes @{Label = 'Add-LShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'steelblue' } {

            Add-NodeShape -Name 'L-Server-Top' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'steelblue' -DraftMode:$DraftMode
            Add-NodeShape -Name 'L-Server-Right' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'steelblue' -DraftMode:$DraftMode

            Add-LShapeLine -LShapeUp 'L-JunctionUp' -LShapeDown 'L-JunctionDown' -LShapeRight 'L-JunctionRight' -LineColor 'steelblue' -LineWidth 2 -LShapeUpLineLength 2 -LShapeRightLineLength 2 -DraftMode:$DraftMode

            Edge -From 'L-Server-Top' -To 'L-JunctionUp' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'steelblue'; penwidth = 2 }
            Edge -From 'L-JunctionRight' -To 'L-Server-Right' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'steelblue'; penwidth = 2 }
            Rank 'L-JunctionRight', 'L-Server-Right'
        }

        <#
            -- Add-LeftLShapeLine ---
            Creates a left-oriented L-shaped connector: a horizontal line from the left to
            a corner node at the top, then a vertical line from the corner downward.

            Visual:
                        (LeftLShapeUp)
            (LeftLShapeLeft) o______o
                                    |
                                    o (LeftLShapeDown)

            Parameters:
            - LeftLShapeUp:             Name of the corner node at the top.
            - LeftLShapeDown:           Name of the bottom endpoint of the vertical segment.
            - LeftLShapeLeft:           Name of the left endpoint of the horizontal segment.
            - LeftLShapeUpLineLength:   Minimum length of the vertical segment (1-10).
            - LeftLShapeLeftLineLength: Minimum length of the horizontal segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph LeftLShapeDemo -Attributes @{Label = 'Add-LeftLShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'darkorange' } {

            Add-NodeShape -Name 'LL-Server-Left' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkorange' -DraftMode:$DraftMode
            Add-NodeShape -Name 'LL-Server-Bottom' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkorange' -DraftMode:$DraftMode

            Add-LeftLShapeLine -LeftLShapeUp 'LL-JunctionUp' -LeftLShapeDown 'LL-JunctionDown' -LeftLShapeLeft 'LL-JunctionLeft' -LineColor 'darkorange' -LineWidth 2 -LeftLShapeUpLineLength 2 -LeftLShapeLeftLineLength 2 -DraftMode:$DraftMode

            Edge -From 'LL-Server-Left' -To 'LL-JunctionLeft' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkorange'; penwidth = 2 }
            Rank 'LL-Server-Left', 'LL-JunctionLeft'
            Edge -From 'LL-JunctionDown' -To 'LL-Server-Bottom' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkorange'; penwidth = 2 }
        }

        <#
            -- Add-RightLShapeLine ---
            Creates a right-facing L-shaped connector: a horizontal line from the corner to
            the right, and a vertical line from the corner downward.

            Visual:
                        (RightLShapeUp)
                                o_____o(RightLShapeRight)
                                |
                  (RightLShapeDown) o

            Parameters:
            - RightLShapeUp:              Name of the corner node at the top.
            - RightLShapeDown:            Name of the bottom endpoint of the vertical segment.
            - RightLShapeRight:           Name of the right endpoint of the horizontal segment.
            - RightLShapeUpLineLength:    Minimum length of the vertical segment (1-10).
            - RightLShapeRightLineLength: Minimum length of the horizontal segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph RightLShapeDemo -Attributes @{Label = 'Add-RightLShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'darkgreen' } {

            Add-NodeShape -Name 'RL-Server-Right' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkgreen' -DraftMode:$DraftMode
            Add-NodeShape -Name 'RL-Server-Bottom' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkgreen' -DraftMode:$DraftMode

            Add-RightLShapeLine -RightLShapeUp 'RL-JunctionUp' -RightLShapeDown 'RL-JunctionDown' -RightLShapeRight 'RL-JunctionRight' -LineColor 'darkgreen' -LineWidth 2 -RightLShapeUpLineLength 2 -RightLShapeRightLineLength 2 -DraftMode:$DraftMode

            Edge -From 'RL-JunctionRight' -To 'RL-Server-Right' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkgreen'; penwidth = 2 }
            Edge -From 'RL-JunctionDown' -To 'RL-Server-Bottom' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkgreen'; penwidth = 2 }

            Rank 'RL-Server-Right', 'RL-JunctionRight'
        }
    }

    SubGraph InvertedLShapeGroup -Attributes @{Label = 'Inverted L-Shape Connector'; fontsize = 20; penwidth = 2; labelloc = 't'; style = 'dashed,rounded'; color = 'darkgray' } {

        <#
            -- Add-InvertedLShapeLine ---
            Creates an inverted L-shaped connector: a vertical line from a corner node
            upward, and a horizontal line from the corner to the right.

            Visual:
                    (InvertedLShapeUp)  o___o (InvertedLShapeRight)
                                        |
                                        o
                                (InvertedLShapeDown)

            Parameters:
            - InvertedLShapeUp:             Name of the corner node at the top.
            - InvertedLShapeDown:           Name of the bottom endpoint of the vertical segment.
            - InvertedLShapeRight:          Name of the right endpoint of the horizontal segment.
            - InvertedLShapeUpLineLength:   Minimum length of the vertical segment (1-10).
            - InvertedLShapeRightLineLength:Minimum length of the horizontal segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph InvertedLShapeDemo -Attributes @{Label = 'Add-InvertedLShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'purple' } {

            Add-NodeShape -Name 'IL-Server-Right' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'purple' -DraftMode:$DraftMode
            Add-NodeShape -Name 'IL-Server-Bottom' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'purple' -DraftMode:$DraftMode

            Add-InvertedLShapeLine -InvertedLShapeUp 'IL-JunctionUp' -InvertedLShapeDown 'IL-JunctionDown' -InvertedLShapeRight 'IL-JunctionRight' -LineColor 'purple' -LineWidth 2 -InvertedLShapeUpLineLength 2 -InvertedLShapeRightLineLength 2 -DraftMode:$DraftMode

            Edge -From 'IL-JunctionRight' -To 'IL-Server-Right' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'purple'; penwidth = 2 }
            Edge -From 'IL-JunctionDown' -To 'IL-Server-Bottom' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'purple'; penwidth = 2 }

            Rank 'IL-Server-Right', 'IL-JunctionRight'
        }
    }

    SubGraph TShapeGroup -Attributes @{Label = 'T-Shape Connectors'; fontsize = 20; penwidth = 2; labelloc = 't'; style = 'dashed,rounded'; color = 'darkgray' } {

        <#
            -- Add-TShapeLine
            Creates a T-shaped connector: a horizontal line between a left node, a center
            (top) node, and a right node, with a vertical line extending downward from center.

            Visual:
                                    (TShapeMiddleUp)
                    (TShapeLeft)o___o___o(TShapeRight)
                                    |
                                    o
                                    (TShapeMiddleDown)

            Parameters:
            - TShapeLeft:               Name of the left endpoint of the horizontal line.
            - TShapeRight:              Name of the right endpoint of the horizontal line.
            - TShapeMiddleUp:           Name of the center/junction node on the horizontal line.
            - TShapeMiddleDown:         Name of the bottom endpoint of the vertical line.
            - TShapeLeftLineLength:     Minimum length of the left horizontal segment (1-10).
            - TShapeRightLineLength:    Minimum length of the right horizontal segment (1-10).
            - TShapeMiddleDownLineLength: Minimum length of the vertical segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph TShapeDemo -Attributes @{Label = 'Add-TShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'firebrick' } {

            Add-NodeShape -Name 'T-Server-Left' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'firebrick' -DraftMode:$DraftMode
            Add-NodeShape -Name 'T-Server-Right' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'firebrick' -DraftMode:$DraftMode
            Add-NodeShape -Name 'T-Server-Down' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'firebrick' -DraftMode:$DraftMode

            Add-TShapeLine -TShapeLeft 'T-JunctionLeft' -TShapeRight 'T-JunctionRight' -TShapeMiddleUp 'T-JunctionMiddleUp' -TShapeMiddleDown 'T-JunctionMiddleDown' -LineColor 'firebrick' -LineWidth 2 -TShapeLeftLineLength 2 -TShapeRightLineLength 2 -TShapeMiddleDownLineLength 2 -DraftMode:$DraftMode

            Edge -From 'T-Server-Left' -To 'T-JunctionLeft' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'firebrick'; penwidth = 2 }
            Edge -From 'T-JunctionRight' -To 'T-Server-Right' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'firebrick'; penwidth = 2 }
            Edge -From 'T-JunctionMiddleDown' -To 'T-Server-Down' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'firebrick'; penwidth = 2 }

            Rank 'T-Server-Left', 'T-JunctionLeft'
            Rank 'T-Server-Right', 'T-JunctionRight'
        }

        <#
            -- Add-InvertedTShapeLine ---
            Creates an inverted T-shaped connector: a horizontal line between a left node,
            a center node, and a right node, with a vertical line extending upward from center.

            Visual:
                                (InvertedTMiddleTop)
                                        o
                                        |
                    (InvertedTStart)o___|___o(InvertedTEnd)
                                        o
                                (InvertedTMiddleDown)

            Parameters:
            - InvertedTStart:           Name of the left endpoint of the horizontal line.
            - InvertedTEnd:             Name of the right endpoint of the horizontal line.
            - InvertedTMiddleTop:       Name of the top endpoint of the vertical line.
            - InvertedTMiddleDown:      Name of the center/junction node on the horizontal line.
            - InvertedTStartLineLength: Minimum length of the left horizontal segment (1-10).
            - InvertedTEndLineLength:   Minimum length of the right horizontal segment (1-10).
            - InvertedTMiddleTopLength: Minimum length of the vertical segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph InvertedTShapeDemo -Attributes @{Label = 'Add-InvertedTShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'teal' } {

            Add-NodeShape -Name 'IT-Server-Left' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'teal' -DraftMode:$DraftMode
            Add-NodeShape -Name 'IT-Server-Right' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'teal' -DraftMode:$DraftMode
            Add-NodeShape -Name 'IT-Server-Top' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'teal' -DraftMode:$DraftMode

            Add-InvertedTShapeLine -InvertedTStart 'IT-JunctionStart' -InvertedTEnd 'IT-JunctionEnd' -InvertedTMiddleTop 'IT-JunctionMiddleTop' -InvertedTMiddleDown 'IT-JunctionMiddleDown' -LineColor 'teal' -LineWidth 2 -InvertedTStartLineLength 2 -InvertedTEndLineLength 2 -InvertedTMiddleTopLength 2 -DraftMode:$DraftMode

            Edge -From 'IT-Server-Left' -To 'IT-JunctionStart' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'teal'; penwidth = 2 }
            Edge -From 'IT-JunctionEnd' -To 'IT-Server-Right' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'teal'; penwidth = 2 }
            Edge -From 'IT-Server-Top' -To 'IT-JunctionMiddleTop' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'teal'; penwidth = 2 }

            Rank 'IT-Server-Left', 'IT-JunctionStart'
            Rank 'IT-Server-Right', 'IT-JunctionEnd'
        }
    }

    SubGraph SideTShapeGroup -Attributes @{Label = 'Side T-Shape Connectors'; fontsize = 20; penwidth = 2; labelloc = 't'; style = 'dashed,rounded'; color = 'darkgray' } {

        <#
            -- Add-LeftTShapeLine ---
            Creates a Left T-shaped connector: a vertical line through a center node (up and
            down), with a horizontal branch extending to the left from the center.

            Visual:
                            (LeftTShapeUp)
                                    o
                                    |
          (LeftTShapeMiddleLeft)o___o (LeftTShapeMiddleRight)
                                    |
                                    o
                            (LeftTShapeDown)

            Parameters:
            - LeftTShapeUp:                  Name of the top endpoint of the vertical line.
            - LeftTShapeDown:                Name of the bottom endpoint of the vertical line.
            - LeftTShapeMiddleRight:         Name of the right horizontal endpoint.
            - LeftTShapeMiddleLeft:          Name of the center/junction node.
            - LeftTShapeUpLineLength:        Minimum length of the upper vertical segment (1-10).
            - LeftTShapeDownLineLength:      Minimum length of the lower vertical segment (1-10).
            - LeftTShapeMiddleLeftLineLength:Minimum length of the horizontal segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph LeftTShapeDemo -Attributes @{Label = 'Add-LeftTShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'indigo' } {

            Add-NodeShape -Name 'LT-Server-Top' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'indigo' -DraftMode:$DraftMode
            Add-NodeShape -Name 'LT-Server-Bottom' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'indigo' -DraftMode:$DraftMode
            Add-NodeShape -Name 'LT-Server-Left' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'indigo' -DraftMode:$DraftMode

            Add-LeftTShapeLine -LeftTShapeUp 'LT-JunctionUp' -LeftTShapeDown 'LT-JunctionDown' -LeftTShapeMiddleRight 'LT-JunctionMiddleRight' -LeftTShapeMiddleLeft 'LT-JunctionMiddleLeft' -LineColor 'indigo' -LineWidth 2 -LeftTShapeUpLineLength 2 -LeftTShapeDownLineLength 2 -LeftTShapeMiddleLeftLineLength 2 -DraftMode:$DraftMode

            Edge -From 'LT-Server-Top' -To 'LT-JunctionUp' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'indigo'; penwidth = 2 }
            Edge -From 'LT-JunctionDown' -To 'LT-Server-Bottom' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'indigo'; penwidth = 2 }
            Edge -From 'LT-Server-Left' -To 'LT-JunctionMiddleLeft' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'indigo'; penwidth = 2 }

            Rank 'LT-Server-Left', 'LT-JunctionMiddleLeft'
        }

        <#
            -- Add-RightTShapeLine ---
            Creates a Right T-shaped connector: a vertical line through a center node (up and
            down), with a horizontal branch extending to the right from the center.

            Visual:
                                    (RightTShapeUp)
                                            o
                                            |
                (RightTShapeMiddleLeft)o___o(RightTShapeMiddleRight)
                                            |
                                            o
                                    (RightTShapeDown)

            Parameters:
            - RightTShapeUp:                    Name of the top endpoint of the vertical line.
            - RightTShapeDown:                  Name of the bottom endpoint of the vertical line.
            - RightTShapeMiddleRight:           Name of the right horizontal endpoint.
            - RightTShapeMiddleLeft:            Name of the center/junction node.
            - RightTShapeUpLineLength:          Minimum length of the upper vertical segment (1-10).
            - RightTShapeDownLineLength:        Minimum length of the lower vertical segment (1-10).
            - RightTShapeMiddleRightLineLength: Minimum length of the horizontal segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph RightTShapeDemo -Attributes @{Label = 'Add-RightTShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'saddlebrown' } {

            Add-NodeShape -Name 'RT-Server-Top' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'saddlebrown' -DraftMode:$DraftMode
            Add-NodeShape -Name 'RT-Server-Bottom' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'saddlebrown' -DraftMode:$DraftMode
            Add-NodeShape -Name 'RT-Server-Right' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'saddlebrown' -DraftMode:$DraftMode

            Add-RightTShapeLine -RightTShapeUp 'RT-JunctionUp' -RightTShapeDown 'RT-JunctionDown' -RightTShapeMiddleRight 'RT-JunctionMiddleRight' -RightTShapeMiddleLeft 'RT-JunctionMiddleLeft' -LineColor 'saddlebrown' -LineWidth 2 -RightTShapeUpLineLength 2 -RightTShapeDownLineLength 2 -RightTShapeMiddleRightLineLength 2 -DraftMode:$DraftMode

            Edge -From 'RT-Server-Top' -To 'RT-JunctionUp' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'saddlebrown'; penwidth = 2 }
            Edge -From 'RT-JunctionDown' -To 'RT-Server-Bottom' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'saddlebrown'; penwidth = 2 }
            Edge -From 'RT-JunctionMiddleRight' -To 'RT-Server-Right' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'saddlebrown'; penwidth = 2 }

            Rank 'RT-Server-Right', 'RT-JunctionMiddleRight'
        }
    }

    SubGraph CrossShapeGroup -Attributes @{Label = 'Cross Shape Connector'; fontsize = 20; penwidth = 2; labelloc = 't'; style = 'dashed,rounded'; color = 'darkgray' } {

        <#
            -- Add-CrossShapeLine ---
            Creates a cross-shaped (plus sign) connector: a horizontal line between a start
            node, a center node, and an end node, with vertical lines extending up and down
            from the center.

            Visual:
                                        (CrossShapeMiddleTop)
                                                o
                                                |
                       (CrossShapeStart)o___o___o(CrossShapeEnd)
                                                |
                                                o
                                        (CrossShapeMiddleDown)

            Parameters:
            - CrossShapeStart:              Name of the left endpoint of the horizontal line.
            - CrossShapeEnd:                Name of the right endpoint of the horizontal line.
            - CrossShapeMiddle:             Name of the center/junction node.
            - CrossShapeMiddleTop:          Name of the top endpoint of the vertical line.
            - CrossShapeMiddleDown:         Name of the bottom endpoint of the vertical line.
            - CrossShapeStartLineLength:    Minimum length of the left horizontal segment (1-10).
            - CrossShapeEndLineLength:      Minimum length of the right horizontal segment (1-10).
            - CrossShapeMiddleTopLineLength: Minimum length of the upper vertical segment (1-10).
            - CrossShapeMiddleDownLineLength:Minimum length of the lower vertical segment (1-10).
            - LineStyle, LineWidth, LineColor, IconDebug: See Add-LShapeLine.
        #>

        SubGraph CrossShapeDemo -Attributes @{Label = 'Add-CrossShapeLine'; fontsize = 16; penwidth = 1.5; labelloc = 't'; style = 'rounded'; color = 'darkred' } {

            Add-NodeShape -Name 'X-Server-Left' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkred' -DraftMode:$DraftMode
            Add-NodeShape -Name 'X-Server-Right' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkred' -DraftMode:$DraftMode
            Add-NodeShape -Name 'X-Server-Top' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkred' -DraftMode:$DraftMode
            Add-NodeShape -Name 'X-Server-Bottom' -Shape rectangle -ShapeFillColor 'lightyellow' -ShapeStyle 'filled' -ShapeWidth 1.5 -ShapeHeight 0.5 -ShapeLineColor 'darkred' -DraftMode:$DraftMode

            Add-CrossShapeLine -CrossShapeStart 'X-JunctionStart' -CrossShapeEnd 'X-JunctionEnd' -CrossShapeMiddle 'X-JunctionMiddle' -CrossShapeMiddleTop 'X-JunctionTop' -CrossShapeMiddleDown 'X-JunctionDown' -LineColor 'darkred' -LineWidth 2 -CrossShapeStartLineLength 2 -CrossShapeEndLineLength 2 -CrossShapeMiddleTopLineLength 2 -CrossShapeMiddleDownLineLength 2 -DraftMode:$DraftMode

            Edge -From 'X-Server-Left' -To 'X-JunctionStart' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkred'; penwidth = 2 }
            Edge -From 'X-JunctionEnd' -To 'X-Server-Right' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkred'; penwidth = 2 }
            Edge -From 'X-Server-Top' -To 'X-JunctionTop' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkred'; penwidth = 2 }
            Edge -From 'X-JunctionDown' -To 'X-Server-Bottom' @{arrowhead = 'none'; arrowtail = 'none'; style = 'solid'; color = 'darkred'; penwidth = 2 }

            Rank 'X-Server-Left', 'X-JunctionStart'
            Rank 'X-Server-Right', 'X-JunctionEnd'
        }
    }
}

<#
    The New-AbrDiagram cmdlet generates the diagram.
#>

New-AbrDiagram -InputObject $example17 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example17 -LogoName 'Main_Logo' -Direction top-to-bottom -IconPath $IconPath -ImagesObj $Images -DraftMode:$DraftMode
