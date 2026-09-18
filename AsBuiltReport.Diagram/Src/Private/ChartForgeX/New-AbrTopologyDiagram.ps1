function New-AbrTopologyDiagram {
    <#
    .SYNOPSIS
        Creates a new ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Part of the ChartForgeX DSL. Creates the root TopologyChart object consumed by every
        Add-AbrTopology* function and rendered by Export-AbrTopologyDiagram.
    .EXAMPLE
        $Diagram = New-AbrTopologyDiagram -Id 'MyDiagram' -Title 'My Diagram' -LayoutDirection LeftToRight
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Id
        Unique identifier for the diagram.
    .PARAMETER Title
        Diagram title.
    .PARAMETER Subtitle
        Diagram subtitle.
    .PARAMETER LayoutMode
        Layout algorithm used to arrange nodes. Defaults to 'Layered'.
    .PARAMETER LayoutDirection
        Direction the layout should flow. Defaults to 'TopToBottom'.
    .PARAMETER Theme
        Built-in color theme (Light or Dark).
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyChart])]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Please provide a unique identifier for the diagram')]
        [ValidateNotNullOrEmpty()]
        [string] $Id,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the diagram title')]
        [string] $Title,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the diagram subtitle')]
        [string] $Subtitle,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the layout algorithm used to arrange nodes')]
        [ChartForgeX.Topology.TopologyLayoutMode] $LayoutMode = [ChartForgeX.Topology.TopologyLayoutMode]::Layered,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the direction the layout should flow')]
        [ChartForgeX.Topology.TopologyLayoutDirection] $LayoutDirection = [ChartForgeX.Topology.TopologyLayoutDirection]::TopToBottom,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the built-in color theme (Light or Dark)')]
        [ValidateSet('Light', 'Dark')]
        [string] $Theme
    )

    process {
        try {
            $Params = @{
                Id              = $Id
                LayoutMode      = $LayoutMode
                LayoutDirection = $LayoutDirection
            }
            if ($Title) { $Params.Title = $Title }
            if ($Subtitle) { $Params.Subtitle = $Subtitle }
            if ($Theme) { $Params.Theme = $Theme }

            New-TopologyChart @Params
        } catch {
            Write-Error "Failed to create ChartForgeX topology diagram: $($_.Exception.Message)"
        }
    }
}
