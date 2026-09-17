function Add-AbrTopologyGroup {
    <#
    .SYNOPSIS
        Adds a logical group/cluster region to a ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Part of the ChartForgeX DSL (see New-AbrTopologyDiagram). Equivalent to a Graphviz
        subgraph/cluster; nodes reference the group via -GroupId on Add-AbrTopologyNode.
    .EXAMPLE
        $Diagram = $Diagram | Add-AbrTopologyGroup -Id 'Dmz' -Label 'DMZ'
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Diagram
        The TopologyChart object returned by New-AbrTopologyDiagram (or a previous Add-AbrTopology* call).
    .PARAMETER Id
        Unique identifier for the group.
    .PARAMETER Label
        Display label for the group.
    .PARAMETER X
        X coordinate. Ignored by auto layout modes.
    .PARAMETER Y
        Y coordinate. Ignored by auto layout modes.
    .PARAMETER Width
        Group width in pixels.
    .PARAMETER Height
        Group height in pixels.
    .PARAMETER Status
        Health status badge.
    .PARAMETER Subtitle
        Secondary line of text under the label.
    .PARAMETER Color
        Foreground/accent color (hex).
    .PARAMETER IconId
        Built-in catalog icon id shown in the group header.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyChart])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Please provide the diagram returned by New-AbrTopologyDiagram')]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyChart] $Diagram,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide a unique identifier for the group')]
        [ValidateNotNullOrEmpty()]
        [string] $Id,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the display label for the group')]
        [ValidateNotNullOrEmpty()]
        [string] $Label,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the X coordinate')]
        [double] $X,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the Y coordinate')]
        [double] $Y,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the group width in pixels')]
        [double] $Width = 320,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the group height in pixels')]
        [double] $Height = 240,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the health status badge')]
        [ChartForgeX.Topology.TopologyHealthStatus] $Status = [ChartForgeX.Topology.TopologyHealthStatus]::Unknown,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide a secondary line of text under the label')]
        [string] $Subtitle,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the foreground/accent color (hex)')]
        [string] $Color,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the built-in catalog icon id shown in the group header')]
        [string] $IconId
    )

    process {
        try {
            $Params = @{
                Chart  = $Diagram
                Id     = $Id
                Label  = $Label
                X      = $X
                Y      = $Y
                Width  = $Width
                Height = $Height
                Status = $Status
            }
            if ($Subtitle) { $Params.Subtitle = $Subtitle }
            if ($Color) { $Params.Color = $Color }
            if ($IconId) { $Params.IconId = $IconId }

            Add-TopologyGroup @Params
        } catch {
            Write-Error "Failed to add ChartForgeX topology group: $($_.Exception.Message)"
        }
    }
}
