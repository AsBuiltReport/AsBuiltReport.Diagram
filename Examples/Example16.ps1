<#
    This example demonstrates how to use the Add-DiaNodeEdge cmdlet to add customizable directed edges
    between nodes in a Graphviz diagram, including HTML label support for enhanced connectivity.
    (Part of Diagrammer.Core module)
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

# Import-Module Diagrammer.Core -Force -Verbose:$false

<#
    Since the diagram output is a file, specify the output folder path using $OutputFolderPath.
#>

$OutputFolderPath = Resolve-Path $Path

<#
    The $MainGraphLabel variable sets the main title of the diagram.
#>

$MainGraphLabel = 'Add-DiaNodeEdge Example Diagram'

$example16 = & {
    <#
        This block creates three server nodes and connects them with customizable edges
        using the Add-DiaNodeEdge cmdlet, demonstrating both plain-text and HTML labels.
    #>

    Node -Name 'Web-Server' -Attributes @{Label = 'Web-Server'; shape = 'rectangle'; style = 'filled'; fillcolor = 'lightblue'; fontsize = 14 }
    Node -Name 'App-Server' -Attributes @{Label = 'App-Server'; shape = 'rectangle'; style = 'filled'; fillcolor = 'lightyellow'; fontsize = 14 }
    Node -Name 'DB-Server' -Attributes @{Label = 'DB-Server'; shape = 'rectangle'; style = 'filled'; fillcolor = 'lightgreen'; fontsize = 14 }

    <#
        Add-DiaNodeEdge creates a directed edge between two nodes with customizable appearance.

        Parameters:
        - From:              Source node name (required)
        - To:                Target node name (required)
        - EdgeStyle:         Line style: solid, dashed, dotted, bold (default: solid)
        - EdgeColor:         Edge color as name or hex value (default: black)
        - EdgeThickness:     Line thickness 1-10 (default: 1)
        - Arrowhead:         Arrow style at the target end (default: normal)
        - Arrowtail:         Arrow style at the source end (default: none)
        - EdgeLabel:         Plain text label displayed at the center of the edge
        - HtmlEdgeLabel:     HTML string used as the center label for rich connectivity info
        - EdgeLabelFontSize: Font size for the plain-text label, 8-72 (default: 12)
        - EdgeLabelFontColor:Font color for the plain-text label (default: black)
        - HeadLabel:         Text label near the arrowhead (e.g., interface name)
        - TailLabel:         Text label near the arrowtail (e.g., interface name)
        - LabelDistance:     Distance factor for HeadLabel/TailLabel from the node, 0-10 (default: 1)
        - LabelAngle:        Angle in degrees for HeadLabel/TailLabel, -180 to 180 (default: -25)
        - TailPort:          Port on the source node (e.g., 'e', 'w', 'n', 's')
        - HeadPort:          Port on the target node (e.g., 'e', 'w', 'n', 's')

        See https://psgraph.readthedocs.io/en/latest/Command-Edge/ for reference.
    #>

    # A simple solid black edge with a plain text label
    Add-DiaNodeEdge -From 'Web-Server' -To 'App-Server' -EdgeLabel 'HTTP/HTTPS' -EdgeLabelFontSize 12 -EdgeLabelFontColor 'darkblue'

    <#
        HTML edge label for enhanced connectivity - displays structured connection metadata
        (protocol, port) in a table format on the edge between App-Server and DB-Server.

        The HtmlEdgeLabel parameter accepts any Graphviz HTML-like label string (TABLE element).
        HeadLabel and TailLabel add interface annotations near each endpoint.
    #>
    $DbConnectionLabel = '<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="4"><TR><TD BGCOLOR="lightyellow"><B>SQL</B></TD></TR><TR><TD>Port: 1433</TD></TR><TR><TD>VLAN: 10</TD></TR></TABLE>'

    Add-DiaNodeEdge -From 'App-Server' -To 'DB-Server' `
        -EdgeStyle 'dashed' -EdgeColor '#AA5500' -EdgeThickness 2 `
        -Arrowhead 'vee' -Arrowtail 'diamond' `
        -HtmlEdgeLabel $DbConnectionLabel `
        -HeadLabel 'eth1' -TailLabel 'eth0' -LabelDistance 2
}

<#
    The New-Diagrammer cmdlet generates the diagram.
#>
New-Diagrammer -InputObject $example16 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example16 -DraftMode:$DraftMode
