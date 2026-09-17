function Set-AbrTopologyLegend {
    <#
    .SYNOPSIS
        Attaches a legend to a ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Part of the ChartForgeX DSL (see New-AbrTopologyDiagram, New-AbrTopologyLegend).
    .EXAMPLE
        $Diagram = $Diagram | Set-AbrTopologyLegend -Legend $Legend
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Diagram
        The TopologyChart object returned by New-AbrTopologyDiagram (or a previous Add-AbrTopology* call).
    .PARAMETER Legend
        The TopologyLegend object returned by New-AbrTopologyLegend, populated via Add-AbrTopologyLegendItem.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyChart])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Please provide the diagram returned by New-AbrTopologyDiagram')]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyChart] $Diagram,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the legend returned by New-AbrTopologyLegend')]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyLegend] $Legend
    )

    process {
        try {
            Set-TopologyChartLegend -Chart $Diagram -Legend $Legend
        } catch {
            Write-Error "Failed to set ChartForgeX topology legend: $($_.Exception.Message)"
        }
    }
}
