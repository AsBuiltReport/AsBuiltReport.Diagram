function Add-DiaNodeEdge {
    <#
    .SYNOPSIS
        Adds a customizable directed edge between two nodes in a Graphviz diagram.

    .DESCRIPTION
        The Add-DiaNodeEdge function creates a directed edge between two specified nodes in a Graphviz diagram.
        It supports customization of the edge's appearance, including style, color, thickness, arrow types at
        both ends, label text, label font size and color, as well as port specifications for the tail and head
        of the edge.

    .PARAMETER From
        Specifies the name of the source node for the edge. This is a required parameter.

    .PARAMETER To
        Specifies the name of the target node for the edge. This is a required parameter.

    .PARAMETER EdgeStyle
        The style of the edge line. Valid values are 'solid', 'dashed', 'dotted', 'bold'. Default is 'solid'.

    .PARAMETER EdgeColor
        The color of the edge. Accepts any Graphviz-supported color name or hex value (e.g., '#FF0000').
        Default is 'black'. See https://graphviz.org/doc/info/colors.html for supported colors.

    .PARAMETER EdgeThickness
        The thickness (penwidth) of the edge line, ranging from 1 to 10. Default is 1.

    .PARAMETER Arrowhead
        The arrow style at the head (end/target) of the edge. Valid values include 'none', 'normal', 'inv',
        'dot', 'invdot', 'odot', 'invodot', 'diamond', 'odiamond', 'ediamond', 'crow', 'box', 'obox',
        'open', 'halfopen', 'empty', 'invempty', 'tee', 'vee'. Default is 'normal'.

    .PARAMETER Arrowtail
        The arrow style at the tail (start/source) of the edge. Valid values include 'none', 'normal', 'inv',
        'dot', 'invdot', 'odot', 'invodot', 'diamond', 'odiamond', 'ediamond', 'crow', 'box', 'obox',
        'open', 'halfopen', 'empty', 'invempty', 'tee', 'vee'. Default is 'none'.

    .PARAMETER EdgeLabel
        A text label to display on the edge. Default is an empty string (no label).

    .PARAMETER EdgeLabelFontSize
        The font size for the edge label, ranging from 8 to 72. Default is 12.

    .PARAMETER EdgeLabelFontColor
        The font color for the edge label. Accepts any Graphviz-supported color name or hex value.
        Default is 'black'.

    .PARAMETER TailPort
        The port on the source node where the edge originates. Used for fine-grained connection placement.

    .PARAMETER HeadPort
        The port on the target node where the edge terminates. Used for fine-grained connection placement.

    .EXAMPLE
        Add-DiaNodeEdge -From 'NodeA' -To 'NodeB'

        Creates a simple directed edge from NodeA to NodeB with default attributes (solid black line, normal arrowhead).

    .EXAMPLE
        Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeStyle 'dashed' -EdgeColor '#FF0000' -EdgeThickness 2 -Arrowhead 'vee' -EdgeLabel 'Connection'

        Creates a dashed red edge of thickness 2 from NodeA to NodeB with a 'vee' arrowhead and 'Connection' label.

    .EXAMPLE
        Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabel 'Link' -EdgeLabelFontSize 10 -EdgeLabelFontColor 'blue' -TailPort 'e' -HeadPort 'w'

        Creates an edge from NodeA to NodeB with a blue 'Link' label at font size 10, originating from the east
        port of NodeA and terminating at the west port of NodeB.

    .NOTES
        Version:        0.2.40
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux

    .LINK
        https://github.com/rebelinux/Diagrammer.Core
        https://psgraph.readthedocs.io/en/latest/Command-Edge/
    #>

    [CmdletBinding()]
    [OutputType([System.String])]
    param(

        [Parameter(
            Mandatory,
            HelpMessage = 'Name of the source node for the edge.'
        )]
        [string] $From,

        [Parameter(
            Mandatory,
            HelpMessage = 'Name of the target node for the edge.'
        )]
        [string] $To,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The style of the edge line. Valid values: solid, dashed, dotted, bold. Default is solid.'
        )]
        [ValidateSet('solid', 'dashed', 'dotted', 'bold')]
        [string] $EdgeStyle = 'solid',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The color of the edge. Accepts Graphviz color names or hex values (e.g., #FF0000). Default is black.'
        )]
        [string] $EdgeColor = 'black',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The thickness (penwidth) of the edge line, from 1 to 10. Default is 1.'
        )]
        [ValidateRange(1, 10)]
        [int] $EdgeThickness = 1,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The arrow style at the head (target) of the edge. Default is normal.'
        )]
        [ValidateSet('none', 'normal', 'inv', 'dot', 'invdot', 'odot', 'invodot', 'diamond', 'odiamond', 'ediamond', 'crow', 'box', 'obox', 'open', 'halfopen', 'empty', 'invempty', 'tee', 'vee')]
        [string] $Arrowhead = 'normal',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The arrow style at the tail (source) of the edge. Default is none.'
        )]
        [ValidateSet('none', 'normal', 'inv', 'dot', 'invdot', 'odot', 'invodot', 'diamond', 'odiamond', 'ediamond', 'crow', 'box', 'obox', 'open', 'halfopen', 'empty', 'invempty', 'tee', 'vee')]
        [string] $Arrowtail = 'none',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'A text label to display on the edge. Default is empty (no label).'
        )]
        [string] $EdgeLabel = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The font size for the edge label, from 8 to 72. Default is 12.'
        )]
        [ValidateRange(8, 72)]
        [int] $EdgeLabelFontSize = 12,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The font color for the edge label. Accepts Graphviz color names or hex values. Default is black.'
        )]
        [string] $EdgeLabelFontColor = 'black',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The port on the source node where the edge originates.'
        )]
        [string] $TailPort = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The port on the target node where the edge terminates.'
        )]
        [string] $HeadPort = ''
    )

    begin {}

    process {
        try {
            $EdgeAttributes = @{
                style     = $EdgeStyle
                color     = $EdgeColor
                penwidth  = $EdgeThickness
                arrowhead = $Arrowhead
                arrowtail = $Arrowtail
                fontsize  = $EdgeLabelFontSize
                fontcolor = $EdgeLabelFontColor
            }

            if ($EdgeLabel) {
                $EdgeAttributes['label'] = $EdgeLabel
            }

            if ($TailPort) {
                $EdgeAttributes['tailport'] = $TailPort
            }

            if ($HeadPort) {
                $EdgeAttributes['headport'] = $HeadPort
            }

            Edge -From $From -To $To $EdgeAttributes

        } catch {
            Write-Verbose -Message $_.Exception.Message
        }
    }

    end {}
}
