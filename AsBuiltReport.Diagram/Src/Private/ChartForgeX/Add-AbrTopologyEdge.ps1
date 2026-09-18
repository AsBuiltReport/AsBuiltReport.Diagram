function Add-AbrTopologyEdge {
    <#
    .SYNOPSIS
        Adds an edge (connection) between two nodes in a ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Part of the ChartForgeX DSL (see New-AbrTopologyDiagram, Add-AbrTopologyNode).
    .EXAMPLE
        $Diagram = $Diagram | Add-AbrTopologyEdge -Id 'WebApp' -SourceId 'Web01' -TargetId 'App01' -Label 'HTTPS' -Kind DataFlow
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Diagram
        The TopologyChart object returned by New-AbrTopologyDiagram (or a previous Add-AbrTopology* call).
    .PARAMETER Id
        Unique identifier for the edge.
    .PARAMETER SourceId
        Identifier of the source node.
    .PARAMETER TargetId
        Identifier of the target node.
    .PARAMETER Label
        Label displayed on the edge.
    .PARAMETER Kind
        Semantic edge kind (Link, Dependency, Trust, DataFlow, etc.).
    .PARAMETER Status
        Health status badge.
    .PARAMETER Direction
        Arrow direction.
    .PARAMETER Routing
        Edge routing style.
    .PARAMETER Color
        Foreground/accent color (hex).
    .PARAMETER Tooltip
        Tooltip text shown on hover.
    .PARAMETER LineStyle
        Line style override (Solid, Dashed, Dotted).
    .PARAMETER Emphasis
        Relative line prominence. Strong renders a more prominent connection; Subtle renders a
        lower-emphasis relationship.
    .PARAMETER StrokeWidth
        Edge-specific stroke width in pixels.
    .PARAMETER DashPattern
        Alternating dash and gap lengths in pixels.
    .PARAMETER SourcePortId
        Named source-node port created with Add-TopologyNodePort.
    .PARAMETER TargetPortId
        Named target-node port created with Add-TopologyNodePort.
    .PARAMETER PreferredLength
        Soft force-directed layout length hint, not an exact rendered edge length.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyChart])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Please provide the diagram returned by New-AbrTopologyDiagram')]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyChart] $Diagram,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide a unique identifier for the edge')]
        [ValidateNotNullOrEmpty()]
        [string] $Id,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the identifier of the source node')]
        [ValidateNotNullOrEmpty()]
        [string] $SourceId,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the identifier of the target node')]
        [ValidateNotNullOrEmpty()]
        [string] $TargetId,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the label displayed on the edge')]
        [string] $Label,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the semantic edge kind (Link, Dependency, Trust, DataFlow, etc.)')]
        [ChartForgeX.Topology.TopologyEdgeKind] $Kind = [ChartForgeX.Topology.TopologyEdgeKind]::Generic,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the health status badge')]
        [ChartForgeX.Topology.TopologyHealthStatus] $Status = [ChartForgeX.Topology.TopologyHealthStatus]::Unknown,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the arrow direction')]
        [ChartForgeX.Primitives.VisualLinkDirection] $Direction = [ChartForgeX.Primitives.VisualLinkDirection]::Forward,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the edge routing style')]
        [ChartForgeX.Topology.TopologyEdgeRouting] $Routing = [ChartForgeX.Topology.TopologyEdgeRouting]::Orthogonal,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the foreground/accent color (hex)')]
        [string] $Color,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the tooltip text shown on hover')]
        [string] $Tooltip,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the line style override (Solid, Dashed, Dotted)')]
        [ChartForgeX.Topology.TopologyEdgeLineStyle] $LineStyle,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the relative line prominence (Normal, Subtle, Strong)')]
        [ChartForgeX.Topology.TopologyEdgeEmphasis] $Emphasis,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the named source-node port')]
        [string] $SourcePortId,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the named target-node port')]
        [string] $TargetPortId,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the source endpoint marker (None, Arrow, Circle, Diamond)')]
        [ChartForgeX.Topology.TopologyMarkerKind] $SourceMarker,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the target endpoint marker (None, Arrow, Circle, Diamond)')]
        [ChartForgeX.Topology.TopologyMarkerKind] $TargetMarker,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the edge-specific stroke width in pixels')]
        [double] $StrokeWidth,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the edge-specific opacity from zero to one')]
        [ValidateRange(0.0, 1.0)]
        [double] $Opacity,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide alternating dash and gap lengths in pixels')]
        [double[]] $DashPattern,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the label near the source endpoint')]
        [string] $SourceLabel,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the label near the target endpoint')]
        [string] $TargetLabel,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the preferred spring length for force-directed layouts')]
        [double] $PreferredLength,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the preferred minimum layer separation for layered layouts')]
        [int] $MinimumRankSpan,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the routing and rendering priority')]
        [int] $RoutingPriority
    )

    process {
        try {
            $Params = @{
                Chart    = $Diagram
                Id       = $Id
                SourceId = $SourceId
                TargetId = $TargetId
                Kind     = $Kind
                Status   = $Status
                Direction = $Direction
                Routing  = $Routing
            }
            if ($Label) { $Params.Label = $Label }
            if ($Color) { $Params.Color = $Color }
            if ($Tooltip) { $Params.Tooltip = $Tooltip }
            if ($PSBoundParameters.ContainsKey('LineStyle')) { $Params.LineStyle = $LineStyle }
            if ($PSBoundParameters.ContainsKey('Emphasis')) { $Params.Emphasis = $Emphasis }
            foreach ($Name in @('SourcePortId', 'TargetPortId', 'SourceMarker', 'TargetMarker', 'StrokeWidth', 'Opacity', 'DashPattern', 'SourceLabel', 'TargetLabel', 'PreferredLength', 'MinimumRankSpan', 'RoutingPriority')) {
                if ($PSBoundParameters.ContainsKey($Name)) {
                    $Params[$Name] = $PSBoundParameters[$Name]
                }
            }

            Add-TopologyEdge @Params
        } catch {
            Write-Error "Failed to add ChartForgeX topology edge: $($_.Exception.Message)"
        }
    }
}
