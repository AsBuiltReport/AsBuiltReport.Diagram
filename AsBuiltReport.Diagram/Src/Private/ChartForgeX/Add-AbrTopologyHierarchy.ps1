function Add-AbrTopologyHierarchy {
    <#
    .SYNOPSIS
        Adds a parent-child hierarchy to a ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Projects hierarchy item objects into topology nodes and parent-child edges. Items require Id
        and Label properties; ParentId determines the hierarchy. ChartForgeX infers levels, applies a
        layered layout, and can pack descendant branches using Auto, Standard, Compact, or Vertical policies.
    .EXAMPLE
        $Diagram | Add-AbrTopologyHierarchy -Item @(
            @{ Id = 'Root'; Label = 'Infrastructure' }
            @{ Id = 'Compute'; Label = 'Compute'; ParentId = 'Root' }
        )
    .PARAMETER Item
        Hierarchy items as hashtables, PSCustomObjects, or TopologyHierarchyItem objects. Id and Label
        are required. ParentId, Level, Kind, Status, Subtitle, Symbol, IconId, GroupId, Color,
        BackgroundColor, Width, Height, LayoutPolicy, and Metadata are supported. EdgeLength and
        EdgeWidth configure the generated parent-child edges.
    .PARAMETER LayoutPolicy
        Default policy inherited by hierarchy items without their own LayoutPolicy. An item's explicit
        LayoutPolicy applies to its descendant subtree until a child overrides it. Auto uses a sibling
        band when it fits, Compact when it does not; Standard keeps one band; Compact uses a balanced
        grid; Vertical stacks children in a column.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyChart])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyChart] $Diagram,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [object[]] $Item,

        [int] $MinLevel,

        [int] $MaxLevel,

        [switch] $IncludeAncestorContext,

        [int] $RootLevel,

        [switch] $ApplyLayeredLayout,

        [ChartForgeX.Topology.TopologyLayoutDirection] $LayoutDirection,

        [ChartForgeX.Topology.TopologyHierarchyLayoutPolicy] $LayoutPolicy,

        [ChartForgeX.Topology.TopologyNodeDisplayMode] $NodeDisplayMode,

        [double] $NodeWidth,

        [double] $NodeHeight,

        [ChartForgeX.Topology.TopologyEdgeKind] $EdgeKind,

        [ChartForgeX.Topology.TopologyHealthStatus] $EdgeStatus,

        [ChartForgeX.Primitives.VisualLinkDirection] $EdgeDirection,

        [ChartForgeX.Topology.TopologyEdgeRouting] $EdgeRouting,

        [double] $EdgeLength,

        [double] $EdgeWidth,

        [string] $EdgeIdPrefix
    )

    process {
        try {
            $Params = @{
                Chart = $Diagram
                Items = $Item
            }
            foreach ($Name in $PSBoundParameters.Keys) {
                if ($Name -notin @('Diagram', 'Item')) {
                    $Params[$Name] = $PSBoundParameters[$Name]
                }
            }

            Add-TopologyHierarchy @Params
        } catch {
            Write-Error "Failed to add ChartForgeX topology hierarchy: $($_.Exception.Message)"
        }
    }
}
