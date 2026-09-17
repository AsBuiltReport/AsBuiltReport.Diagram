function Add-AbrTopologyLegendItem {
    <#
    .SYNOPSIS
        Adds a Node, Edge, or Status entry to a ChartForgeX topology legend.
    .DESCRIPTION
        Part of the ChartForgeX DSL (see New-AbrTopologyLegend, Set-AbrTopologyLegend). Use
        -NodeKind, -EdgeKind, or -Status to select which kind of legend entry to add.
    .EXAMPLE
        $Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Server' -NodeKind Server -Color '#16A34A'
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Legend
        The TopologyLegend object returned by New-AbrTopologyLegend (or a previous Add-AbrTopologyLegendItem call).
    .PARAMETER Label
        Label displayed next to the legend entry.
    .PARAMETER Color
        Entry color (hex).
    .PARAMETER NodeKind
        Node kind this legend entry represents.
    .PARAMETER Symbol
        Short symbol/abbreviation shown in the legend swatch.
    .PARAMETER BackgroundColor
        Background fill color of the legend swatch (hex).
    .PARAMETER IconId
        Built-in catalog icon id shown in the legend swatch.
    .PARAMETER EdgeKind
        Edge kind this legend entry represents.
    .PARAMETER LineStyle
        Line style of the legend swatch.
    .PARAMETER Status
        Health status this legend entry represents.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding(DefaultParameterSetName = 'Node')]
    [OutputType([ChartForgeX.Topology.TopologyLegend])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Please provide the legend returned by New-AbrTopologyLegend')]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyLegend] $Legend,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the label displayed next to the legend entry')]
        [ValidateNotNullOrEmpty()]
        [string] $Label,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the entry color (hex)')]
        [string] $Color,

        [Parameter(Mandatory = $true, ParameterSetName = 'Node', HelpMessage = 'Please provide the node kind this legend entry represents')]
        [ChartForgeX.Topology.TopologyNodeKind] $NodeKind,

        [Parameter(Mandatory = $false, ParameterSetName = 'Node', HelpMessage = 'Please provide the short symbol/abbreviation shown in the legend swatch')]
        [string] $Symbol,

        [Parameter(Mandatory = $false, ParameterSetName = 'Node', HelpMessage = 'Please provide the background fill color of the legend swatch (hex)')]
        [string] $BackgroundColor,

        [Parameter(Mandatory = $false, ParameterSetName = 'Node', HelpMessage = 'Please provide the built-in catalog icon id shown in the legend swatch')]
        [string] $IconId,

        [Parameter(Mandatory = $true, ParameterSetName = 'Edge', HelpMessage = 'Please provide the edge kind this legend entry represents')]
        [ChartForgeX.Topology.TopologyEdgeKind] $EdgeKind,

        [Parameter(Mandatory = $false, ParameterSetName = 'Edge', HelpMessage = 'Please provide the line style of the legend swatch')]
        [ChartForgeX.Topology.TopologyEdgeLineStyle] $LineStyle = [ChartForgeX.Topology.TopologyEdgeLineStyle]::Solid,

        [Parameter(Mandatory = $true, ParameterSetName = 'Status', HelpMessage = 'Please provide the health status this legend entry represents')]
        [ChartForgeX.Topology.TopologyHealthStatus] $Status
    )

    process {
        try {
            $Params = @{
                Legend = $Legend
                Label  = $Label
            }
            if ($Color) { $Params.Color = $Color }

            switch ($PSCmdlet.ParameterSetName) {
                'Node' {
                    $Params.NodeKind = $NodeKind
                    if ($Symbol) { $Params.Symbol = $Symbol }
                    if ($BackgroundColor) { $Params.BackgroundColor = $BackgroundColor }
                    if ($IconId) { $Params.IconId = $IconId }
                }
                'Edge' {
                    $Params.EdgeKind = $EdgeKind
                    $Params.LineStyle = $LineStyle
                }
                'Status' {
                    $Params.Status = $Status
                }
            }

            Add-TopologyLegendItem @Params
        } catch {
            Write-Error "Failed to add ChartForgeX topology legend item: $($_.Exception.Message)"
        }
    }
}
