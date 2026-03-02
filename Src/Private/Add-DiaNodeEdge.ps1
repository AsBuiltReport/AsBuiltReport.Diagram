function Add-DiaNodeEdge {
    <#
    .SYNOPSIS
        Adds a customizable directed edge between two nodes in a Graphviz diagram.

    .DESCRIPTION
        The Add-DiaNodeEdge function creates a directed edge between two specified nodes in a Graphviz diagram.
        It supports customization of the edge's appearance, including style, color, thickness, arrow types at
        both ends, plain or HTML label text, label font size and color, endpoint interface/port annotations
        (HeadLabel/TailLabel), and port specifications for the tail and head of the edge.

        HTML labels (via HtmlEdgeLabel) allow rich multi-row table content on the edge to simulate enhanced
        connectivity by displaying structured connection metadata such as protocols, bandwidth, and VLAN tags.

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
        A plain text label to display at the center of the edge. Default is an empty string (no label).
        Mutually exclusive with HtmlEdgeLabel; HtmlEdgeLabel takes precedence when both are provided.

    .PARAMETER HtmlEdgeLabel
        An HTML string to use as the center label of the edge, enabling rich multi-row formatted content
        to simulate enhanced connectivity information (e.g., protocol, bandwidth, VLAN). The value must be
        a valid Graphviz HTML-like label string (e.g., a TABLE element). When provided, takes precedence
        over EdgeLabel.

    .PARAMETER EdgeLabelFontSize
        The font size for the plain-text edge label (EdgeLabel), ranging from 8 to 72. Default is 12.
        Has no effect when HtmlEdgeLabel is used.

    .PARAMETER EdgeLabelFontColor
        The font color for the plain-text edge label (EdgeLabel). Accepts any Graphviz-supported color name
        or hex value. Default is 'black'. Has no effect when HtmlEdgeLabel is used.

    .PARAMETER HeadLabel
        A text label displayed near the arrowhead of the edge. Typically used to annotate the target
        interface or port name (e.g., 'eth0', 'GigE0/1'). Does not affect the center label.

    .PARAMETER TailLabel
        A text label displayed near the arrowtail of the edge. Typically used to annotate the source
        interface or port name (e.g., 'eth1', 'GigE0/2'). Does not affect the center label.

    .PARAMETER LabelDistance
        Controls the distance factor for HeadLabel and TailLabel from the node. Valid range is 0 to 10.
        Default is 1. Only meaningful when HeadLabel or TailLabel is set.

    .PARAMETER LabelAngle
        Controls the angle (in degrees) at which HeadLabel and TailLabel are placed relative to the edge.
        Valid range is -180 to 180. Default is -25. Only meaningful when HeadLabel or TailLabel is set.

    .PARAMETER TailPort
        The port on the source node where the edge originates. Used for fine-grained connection placement.

    .PARAMETER HeadPort
        The port on the target node where the edge terminates. Used for fine-grained connection placement.

    .EXAMPLE
        Add-DiaNodeEdge -From 'NodeA' -To 'NodeB'

        Creates a simple directed edge from NodeA to NodeB with default attributes (solid black line, normal arrowhead).

    .EXAMPLE
        Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeStyle 'dashed' -EdgeColor '#FF0000' -EdgeThickness 2 -Arrowhead 'vee' -EdgeLabel 'Connection'

        Creates a dashed red edge of thickness 2 from NodeA to NodeB with a 'vee' arrowhead and plain text label.

    .EXAMPLE
        $HtmlLabel = '<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0"><TR><TD>Protocol: HTTPS</TD></TR><TR><TD>Port: 443</TD></TR></TABLE>'
        Add-DiaNodeEdge -From 'Web' -To 'App' -HtmlEdgeLabel $HtmlLabel -HeadLabel 'eth0' -TailLabel 'eth1' -LabelDistance 2

        Creates an edge with an HTML table label showing protocol/port details, interface annotations
        near each endpoint, and a label distance of 2.

    .EXAMPLE
        Add-DiaNodeEdge -From 'NodeA' -To 'NodeB' -EdgeLabel 'Link' -EdgeLabelFontSize 10 -EdgeLabelFontColor 'blue' -TailPort 'e' -HeadPort 'w'

        Creates an edge with a blue plain-text label at font size 10, originating from the east
        port of NodeA and terminating at the west port of NodeB.

    .NOTES
        Version:        0.2.40
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux

    .LINK
        https://github.com/rebelinux/Diagrammer.Core
        https://psgraph.readthedocs.io/en/latest/Command-Edge/
        https://graphviz.org/doc/info/attrs.html
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
            HelpMessage = 'A plain text label to display on the edge. Default is empty (no label). HtmlEdgeLabel takes precedence when both are provided.'
        )]
        [string] $EdgeLabel = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'An HTML string to use as the center label of the edge for rich formatted connectivity information. Takes precedence over EdgeLabel when both are provided.'
        )]
        [string] $HtmlEdgeLabel = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The font size for the plain-text edge label, from 8 to 72. Default is 12. Not used when HtmlEdgeLabel is provided.'
        )]
        [ValidateRange(8, 72)]
        [int] $EdgeLabelFontSize = 12,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The font color for the plain-text edge label. Accepts Graphviz color names or hex values. Default is black. Not used when HtmlEdgeLabel is provided.'
        )]
        [string] $EdgeLabelFontColor = 'black',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'A text label displayed near the arrowhead to annotate the target interface or port (e.g., eth0, GigE0/1).'
        )]
        [string] $HeadLabel = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'A text label displayed near the arrowtail to annotate the source interface or port (e.g., eth1, GigE0/2).'
        )]
        [string] $TailLabel = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Distance factor for HeadLabel and TailLabel from the node. Valid range is 0 to 10. Default is 1.'
        )]
        [ValidateRange(0, 10)]
        [double] $LabelDistance = 1,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Angle in degrees for HeadLabel and TailLabel placement relative to the edge. Valid range is -180 to 180. Default is -25.'
        )]
        [ValidateRange(-180, 180)]
        [double] $LabelAngle = -25,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The port on the source node where the edge originates.'
        )]
        [string] $TailPort = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The port on the target node where the edge terminates.'
        )]
        [string] $HeadPort = '',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Sets the minimum edge length (minlen) in rank units. Controls the minimum number of ranks between connected nodes. Valid range is 0 to 10. Default is 1.'
        )]
        [ValidateRange(0, 10)]
        [double] $EdgeLength = 1,


        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Additional Graphviz attributes to add to the edge (e.g., style=filled,color=lightgrey)'
        )]
        [hashtable] $GraphvizAttributes = @{}
    )

    begin {}

    process {
        try {
            $EdgeAttributes = @{
                style = $EdgeStyle
                color = $EdgeColor
                penwidth = $EdgeThickness
                arrowhead = $Arrowhead
                arrowtail = $Arrowtail
                fontsize = $EdgeLabelFontSize
                fontcolor = $EdgeLabelFontColor
            }

            # Merge additional Graphviz attributes
            if ($GraphvizAttributes) {
                $EdgeAttributes = Join-Hashtable -PrimaryHash $EdgeAttributes -SecondaryHash $GraphvizAttributes -PreferSecondary
            }

            # HtmlEdgeLabel takes precedence over plain-text EdgeLabel
            if ($HtmlEdgeLabel) {
                $EdgeAttributes['label'] = $HtmlEdgeLabel
            } elseif ($EdgeLabel) {
                $EdgeAttributes['label'] = $EdgeLabel
            }

            if ($HeadLabel) {
                $EdgeAttributes['headlabel'] = $HeadLabel
            }

            if ($TailLabel) {
                $EdgeAttributes['taillabel'] = $TailLabel
            }

            if ($HeadLabel -or $TailLabel) {
                $EdgeAttributes['labeldistance'] = $LabelDistance
                $EdgeAttributes['labelangle'] = $LabelAngle
            }

            if ($TailPort) {
                $EdgeAttributes['tailport'] = $TailPort
            }

            if ($HeadPort) {
                $EdgeAttributes['headport'] = $HeadPort
            }

            if ($EdgeLength) {
                $EdgeAttributes['minlen'] = $EdgeLength
            }

            Edge -From $From -To $To $EdgeAttributes

        } catch {
            Write-Verbose -Message $_.Exception.Message
            Write-Error -Message $_.Exception.Message
        }
    }

    end {}
}
