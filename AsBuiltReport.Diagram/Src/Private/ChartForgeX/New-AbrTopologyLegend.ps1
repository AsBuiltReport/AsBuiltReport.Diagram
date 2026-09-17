function New-AbrTopologyLegend {
    <#
    .SYNOPSIS
        Creates a new legend for a ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Part of the ChartForgeX DSL (see New-AbrTopologyDiagram). Populate the returned legend with
        Add-AbrTopologyLegendItem, then attach it to a diagram with Set-AbrTopologyLegend.
    .EXAMPLE
        $Legend = New-AbrTopologyLegend -Title 'Legend'
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Title
        Legend title.
    .PARAMETER UseDefaults
        Seed the legend with ChartForgeX's built-in default entries.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyLegend])]
    param (
        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the legend title')]
        [string] $Title = 'Legend',

        [Parameter(Mandatory = $false, HelpMessage = 'Seed the legend with ChartForgeX''s built-in default entries')]
        [switch] $UseDefaults
    )

    process {
        try {
            $Params = @{
                Title = $Title
            }
            if ($UseDefaults) { $Params.UseDefaults = $true }

            New-TopologyLegend @Params
        } catch {
            Write-Error "Failed to create ChartForgeX topology legend: $($_.Exception.Message)"
        }
    }
}
