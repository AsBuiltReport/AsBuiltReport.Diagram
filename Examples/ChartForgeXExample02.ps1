#    ** This example demonstrates how to build a Web Server Farm topology using the ChartForgeX DSL
#       (part of AsBuiltReport.Diagram): groups, multiple nodes sharing a custom icon, built-in icon
#       shapes, a legend, and edges with labels - the ChartForgeX equivalent of Example15.ps1. **

<#
    This example demonstrates how to create a 3-tier web application diagram, complete with a
    web server farm, router, firewall and WAN cloud, using the AsBuiltReport.Diagram ChartForgeX DSL.
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

$OutputFolderPath = Resolve-Path -Path $Path

<#
    Custom icons are embedded directly by Add-AbrTopologyNode via -IconPath (as a base64 data URI),
    so there is no separate -IconPath/ImagesObj plumbing required like the Graphviz engine.
#>

$RootPath = $PSScriptRoot
$IconFolder = Join-Path -Path $RootPath -ChildPath 'Icons'
$ServerRedhatIcon = Join-Path -Path $IconFolder -ChildPath 'Linux_Server_RedHat.png'
$ServerUbuntuIcon = Join-Path -Path $IconFolder -ChildPath 'Linux_Server_Ubuntu.png'
$ServerIcon = Join-Path -Path $IconFolder -ChildPath 'Server.png'
$RouterIcon = Join-Path -Path $IconFolder -ChildPath 'Router.png'
$CloudIcon = Join-Path -Path $IconFolder -ChildPath 'Cloud.png'

$MainGraphLabel = 'Web Application Diagram'

<#
    New-AbrTopologyDiagram creates the root diagram object. Every Add-AbrTopology* function accepts
    that object via the pipeline and returns the updated diagram, so calls can be chained.
#>

$Diagram = New-AbrTopologyDiagram -Id 'ChartForgeXExample02' -Title $MainGraphLabel -Subtitle '3 Tier Concept' -LayoutMode Manual -LayoutDirection TopToBottom

<#
    Add-AbrTopologyGroup creates a logical region (equivalent to the Graphviz SubGraph used in
    Example15.ps1 to contain the web server farm). Group containment is only reliable with the
    'GroupGrid' -LayoutMode (set on New-AbrTopologyDiagram): ChartForgeX's 'Layered' mode can spread
    sibling group members that fan out to a shared external node (e.g. the app tier) across separate
    full-width columns, so a fixed-size group rectangle ends up missing - or wrongly overlapping other
    tiers of - its own members.
#>

$Diagram = $Diagram | Add-AbrTopologyGroup -Id 'WebFarm' -Label 'Web Server Farm' -Status Healthy -Width 600

<#
    This simulates a Web Server Farm with multiple web server nodes sharing similar custom icons,
    each with its own subtitle describing its OS/build (the ChartForgeX equivalent of the
    Add-HtmlNodeTable -MultiIcon feature used in Example15.ps1).
#>

$WebServerFarm = @(
    @{ Id = 'Web01'; Label = 'Web-Server-01'; Subtitle = 'Redhat Linux 10'; IconPath = $ServerRedhatIcon }
    @{ Id = 'Web02'; Label = 'Web-Server-02'; Subtitle = 'Redhat Linux 10'; IconPath = $ServerRedhatIcon }
    @{ Id = 'Web03'; Label = 'Web-Server-03'; Subtitle = 'Ubuntu Linux 24'; IconPath = $ServerUbuntuIcon }
)

foreach ($WebServer in $WebServerFarm) {
    $Diagram = $Diagram | Add-AbrTopologyNode -Id $WebServer.Id -Label $WebServer.Label -Subtitle $WebServer.Subtitle -Kind Server -Status Healthy -GroupId 'WebFarm' -IconPath $WebServer.IconPath
}

<#
    Add-AbrTopologyNode is used again to add the App and Database tier nodes, each with a custom icon
    and a subtitle describing its OS/build (the ChartForgeX equivalent of Add-NodeIcon in Example15.ps1).
#>

$Diagram = $Diagram | Add-AbrTopologyNode -Id 'App01' -Label 'App-Server-01' -Width 200 -Height 64 -Subtitle 'Windows Server 2019' -Kind Application -Status Healthy -IconPath $ServerIcon -X 300 -Y 200
$Diagram = $Diagram | Add-AbrTopologyNode -Id 'Db01' -Label 'Db-Server-01' -Subtitle 'Oracle Server 8' -Kind Database -Status Warning -IconPath $ServerIcon -DisplayMode Pill -Width 200 -Height 200 -X 300 -Y 400

<#
    Add-AbrTopologyEdge connects the web server farm to the app tier, and the app tier to the database.
#>

$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Web01-App01' -SourceId 'Web01' -TargetId 'App01' -Label 'gRPC' -Kind Connectivity
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Web02-App01' -SourceId 'Web02' -TargetId 'App01' -Label 'gRPC' -Kind DataFlow
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Web03-App01' -SourceId 'Web03' -TargetId 'App01' -Label 'gRPC' -Kind DataFlow
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'App01-Db01' -SourceId 'App01' -TargetId 'Db01' -Label 'SQL' -Kind Dependency

<#
    A network router and a WAN cloud are added to represent internet connectivity. Add-NodeIcon's
    custom image feature (Add-NodeImage in Example15.ps1) maps to Add-AbrTopologyNode -IconPath.
#>

$Diagram = $Diagram | Add-AbrTopologyNode -Id 'CoreRouter' -Label 'Core-Router' -Subtitle 'Cisco IOS 15.2' -Kind Network -Status Healthy -IconPath $RouterIcon
$Diagram = $Diagram | Add-AbrTopologyNode -Id 'Wan' -Label 'WAN' -Kind Cloud -Status Unknown -IconPath $CloudIcon

$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'CoreRouter-WebFarm01' -SourceId 'CoreRouter' -TargetId 'Web01' -Label 'GE0/0' -Kind Connectivity
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'CoreRouter-WebFarm02' -SourceId 'CoreRouter' -TargetId 'Web02' -Label 'GE0/0' -Kind Connectivity
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'CoreRouter-WebFarm03' -SourceId 'CoreRouter' -TargetId 'Web03' -Label 'GE0/0' -Kind Connectivity

<#
    Add-AbrTopologyNode -IconShape draws a built-in icon resolved from ChartForgeX's default icon
    catalog, used here to represent a firewall (no custom icon file required). This is the
    ChartForgeX equivalent of the Add-NodeShape cmdlet used in Example15.ps1.
#>

$Diagram = $Diagram | Add-AbrTopologyNode -Id 'Firewall' -Label 'Firewall' -Kind Gateway -Status Healthy -IconShape Firewall

$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Wan-Firewall' -SourceId 'Wan' -TargetId 'Firewall' -Label 'port1' -Kind Connectivity
$Diagram = $Diagram | Add-AbrTopologyEdge -Id 'Firewall-CoreRouter' -SourceId 'Firewall' -TargetId 'CoreRouter' -Label 'Serial0/0' -Kind Connectivity

<#
    New-AbrTopologyLegend / Add-AbrTopologyLegendItem / Set-AbrTopologyLegend build and attach a legend
    describing the node kinds and edge kinds used above.
#>

$Legend = New-AbrTopologyLegend -Title 'Legend'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Server' -NodeKind Server -Color '#16A34A'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Application' -NodeKind Application -Color '#2563EB'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Database' -NodeKind Database -Color '#F97316'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Network' -NodeKind Network -Color '#64748B'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Cloud' -NodeKind Cloud -Color '#0EA5E9'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Data Flow' -EdgeKind DataFlow -Color '#71797E'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Connectivity' -EdgeKind Connectivity -Color '#71797E'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Dependency' -EdgeKind Dependency -Color '#71797E'
$Diagram = $Diagram | Set-AbrTopologyLegend -Legend $Legend

<#
    Export-AbrTopologyDiagram renders the diagram to disk in the requested format(s).
#>

$Diagram | Export-AbrTopologyDiagram -OutputFolderPath $OutputFolderPath -Filename 'ChartForgeXExample02' -Format $Format
