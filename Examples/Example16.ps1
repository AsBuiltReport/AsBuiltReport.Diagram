<#
    This example demonstrates how to use the Add-DiaNodeEdge cmdlet to add customizable directed edges
    between nodes in a Graphviz diagram, including HTML label support for enhanced connectivity.
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

$OutputFolderPath = Resolve-Path $Path

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
    'Main_Logo' = 'Diagrammer.png'
    'Server' = 'Server.png'
    'ServerRedhat' = 'Linux_Server_RedHat.png'
    'ServerUbuntu' = 'Linux_Server_Ubuntu.png'
    'Cloud' = 'Cloud.png'
    'Router' = 'Router.png'
    'Logo_Footer' = 'Signature_Logo.png'
}

<#
    The $MainGraphLabel variable sets the main title of the diagram.
#>

$MainGraphLabel = 'Web Application Diagram'

<#
    This section creates custom objects to hold server information, which are used to set node labels in the diagram.
#>

$WebServerInfo = [PSCustomObject][ordered]@{
    'OS' = 'Redhat Linux'
    'Version' = '10'
    'Build' = '10.1'
    'Edition' = 'Enterprise'
}

$AppServerInfo = [PSCustomObject][ordered]@{
    'OS' = 'Windows Server'
    'Version' = '2019'
    'Build' = '17763.3163'
    'Edition' = 'Datacenter'
}

$DBServerInfo = [PSCustomObject][ordered]@{
    'OS' = 'Oracle Server'
    'Version' = '8'
    'Build' = '8.2'
    'Edition' = 'Enterprise'
}

$example16 = & {
    <#
        This block creates three server nodes and connects them with customizable edges
        using the Add-DiaNodeEdge cmdlet, demonstrating both plain-text and HTML labels.
    #>

    Add-DiaNodeIcon -Name 'Web-Server' -AditionalInfo $WebServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Center' -FontSize 18 -DraftMode:$DraftMode -NodeObject
    Add-DiaNodeIcon -Name 'App-Server' -AditionalInfo $AppServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Center' -FontSize 18 -DraftMode:$DraftMode -NodeObject
    Add-DiaNodeIcon -Name 'DB-Server' -AditionalInfo $DBServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Center' -FontSize 18 -DraftMode:$DraftMode -NodeObject

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
    Add-DiaNodeEdge -From 'Web-Server' -To 'App-Server' -EdgeLabel 'HTTP/HTTPS' -EdgeLabelFontSize 12 -EdgeLabelFontColor 'darkblue' -EdgeThickness 3 -EdgeLength 3 -EdgeStyle 'dashed' -Arrowhead 'vee' -Arrowtail 'dot' -HeadLabel 'eth1' -TailLabel 'Ethernet0' -LabelDistance 2 -LabelAngle 70

    <#
        HTML edge label for enhanced connectivity - displays structured connection metadata
        (protocol, port) in a table format on the edge between App-Server and DB-Server.

        The HtmlEdgeLabel parameter accepts any Graphviz HTML-like label string (TABLE element).
        HeadLabel and TailLabel add interface annotations near each endpoint.
    #>
    $AdditionalInfo = @(
        'Port:'
        '1433'
        'Vlan:'
        '100'
    )

    $DbConnectionLabel = Add-DiaHtmlTable -Name 'DbConnectionLabel' -AdditionalInfo $AdditionalInfo -ColumnSize 2 -TableBorder 1 -TableBorderColor 'black' -FontSize 14 -Subgraph -SubgraphLabel 'SQL' -SubgraphLabelPos 'top' -SubgraphTableStyle 'solid' -SubgraphLabelFontsize 16 -SubgraphFontUnderline -SubgraphFontBold -DraftMode:$DraftMode -TableBackgroundColor 'lightyellow' -CellSpacing 2 -CellPadding 2 -CellBorder 0

    Add-DiaNodeEdge -From 'App-Server' -To 'DB-Server' -EdgeStyle 'dashed' -EdgeColor 'Black' -EdgeThickness 3 -Arrowhead 'vee' -Arrowtail 'dot' -HtmlEdgeLabel $DbConnectionLabel -HeadLabel 'eth1' -TailLabel 'Ethernet0' -LabelDistance 2 -EdgeLength 3 -LabelAngle 70

    <#
        The Rank cmdlet is used to place nodes at the same hierarchical level.
        In this example, App-Server and DB-Server are aligned horizontally.
    #>
    Rank -Nodes 'App-Server', 'DB-Server'
}

<#
    The New-Diagrammer cmdlet generates the diagram.
#>
New-Diagrammer -InputObject $example16 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example16 -LogoName 'Main_Logo' -Direction top-to-bottom -IconPath $IconPath -ImagesObj $Images -DraftMode:$DraftMode