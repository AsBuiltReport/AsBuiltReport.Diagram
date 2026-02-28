<#
    This example demonstrates how to use the Add-DiaNodeEdge cmdlet to add customizable directed edges
    between nodes in a Graphviz diagram. (Part of Diagrammer.Core module)
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
        using the Add-DiaNodeEdge cmdlet.
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
        - EdgeLabel:         Text label displayed on the edge
        - EdgeLabelFontSize: Font size for the label, 8-72 (default: 12)
        - EdgeLabelFontColor:Font color for the label (default: black)
        - TailPort:          Port on the source node (e.g., 'e', 'w', 'n', 's')
        - HeadPort:          Port on the target node (e.g., 'e', 'w', 'n', 's')

        See https://psgraph.readthedocs.io/en/latest/Command-Edge/ for reference.
    #>

    # A simple solid black edge with a label
    Add-DiaNodeEdge -From 'Web-Server' -To 'App-Server' -EdgeLabel 'HTTP/HTTPS' -EdgeLabelFontSize 12 -EdgeLabelFontColor 'darkblue'

    # A dashed edge with a custom color, increased thickness, and a vee arrowhead
    Add-DiaNodeEdge -From 'App-Server' -To 'DB-Server' -EdgeStyle 'dashed' -EdgeColor '#AA5500' -EdgeThickness 2 -Arrowhead 'vee' -EdgeLabel 'SQL' -EdgeLabelFontSize 12 -EdgeLabelFontColor '#AA5500'
}

<#
    The New-Diagrammer cmdlet generates the diagram.
#>
New-Diagrammer -InputObject $example16 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example16 -DraftMode:$DraftMode
