function Add-AbrTopologyNodePort {
    <#
    .SYNOPSIS
        Adds a named attachment port to a node in a ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Named ports let Add-AbrTopologyEdge attach connections to a specific node side using
        -SourcePortId or -TargetPortId.
    .EXAMPLE
        $Diagram = $Diagram | Add-AbrTopologyNodePort -NodeId 'Web01' -Id 'eth0' -Side Right
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
        [string] $NodeId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Id,

        [ChartForgeX.Topology.TopologyEdgePort] $Side = [ChartForgeX.Topology.TopologyEdgePort]::Auto,

        [double] $Offset,

        [string] $Label
    )

    process {
        try {
            $Params = @{
                Chart  = $Diagram
                NodeId = $NodeId
                Id     = $Id
                Side   = $Side
                Offset = $Offset
            }
            if ($Label) { $Params.Label = $Label }

            Add-TopologyNodePort @Params
        } catch {
            Write-Error "Failed to add ChartForgeX topology node port: $($_.Exception.Message)"
        }
    }
}
