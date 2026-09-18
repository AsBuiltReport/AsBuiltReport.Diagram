<#
    Simple example of how to create a 3-tier web application diagram using the AsBuiltReport.Diagram
    ChartForgeX DSL (New-AbrTopologyDiagram / Add-AbrTopologyNode / Add-AbrTopologyEdge / Export-AbrTopologyDiagram).

    Unlike Example01-17 (which use the PSGraph/Graphviz engine via New-AbrDiagram), this DSL renders
    diagrams natively in .NET using ChartForgeX, without requiring a Graphviz 'dot' executable.
#>

[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [ValidateSet('svg', 'png', 'html', 'bmp', 'gif', 'tiff', 'ppm', 'apng', 'base64')]
    [array] $Format = @('svg')
)

<#
    Starting with PowerShell v3, modules are auto-imported when needed. Importing the module here ensures clarity and avoids ambiguity.
#>

# Import-Module AsBuiltReport.Diagram -Force -Verbose:$false

$OutputFolderPath = Resolve-Path $Path

<#
    New-AbrTopologyDiagram creates the root diagram object. Every Add-AbrTopology* function accepts
    that object via the pipeline and returns the updated diagram, so calls can be chained.
#>

$Diagram = New-AbrTopologyDiagram -Id 'ChartForgeXExample01' -Title '3 Tier Web Application Diagram' -LayoutDirection LeftToRight

<#
    Add-AbrTopologyGroup creates a logical region (equivalent to a Graphviz subgraph/cluster).
    Nodes reference it via -GroupId.
#>

$Diagram = $Diagram | Add-AbrTopologyGroup -Id 'Dmz' -Label 'DMZ'

<#
    Add-AbrTopologyNode adds a node. -Kind drives the built-in icon/color; -Status overlays a health badge.
#>

$Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -Kind Server -Status Healthy -GroupId 'Dmz'
$Diagram = $Diagram | Add-AbrTopologyNode -Id 'App01' -Label 'App-Server-01' -Kind Application -Status Healthy
$Diagram = $Diagram | Add-AbrTopologyNode -Id 'Db01' -Label 'Db-Server-01' -Kind Database -Status Warning

<#
    Add-AbrTopologyEdge connects two nodes by Id.
#>

$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'WebApp' -SourceId 'Web01' -TargetId 'App01' -Label 'HTTPS' -Kind DataFlow
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'AppDb' -SourceId 'App01' -TargetId 'Db01' -Label 'SQL' -Kind Dependency

<#
    New-AbrTopologyLegend / Add-AbrTopologyLegendItem / Set-AbrTopologyLegend build and attach a legend.
#>

$Legend = New-AbrTopologyLegend -Title 'Legend'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Server' -NodeKind Server -Color '#16A34A'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Database' -NodeKind Database -Color '#F97316'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Dependency' -EdgeKind Dependency -Color '#71797E'
$Diagram = $Diagram | Set-AbrTopologyLegend -Legend $Legend

<#
    Export-AbrTopologyDiagram renders the diagram to disk in the requested format(s).
#>

$Diagram | Export-AbrTopologyDiagram -OutputFolderPath $OutputFolderPath -Filename 'ChartForgeXExample01' -Format $Format
