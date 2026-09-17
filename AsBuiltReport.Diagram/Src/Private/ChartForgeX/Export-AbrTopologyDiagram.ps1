function Export-AbrTopologyDiagram {
    <#
    .SYNOPSIS
        Renders a ChartForgeX-backed topology diagram to disk (or to a base64 string).
    .DESCRIPTION
        Part of the ChartForgeX DSL (see New-AbrTopologyDiagram). Wraps Export-TopologyChart and
        additionally supports a 'base64' format by rendering a temporary PNG and encoding it.
    .EXAMPLE
        $Diagram | Export-AbrTopologyDiagram -OutputFolderPath 'C:\Temp' -Filename 'MyDiagram' -Format svg
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Diagram
        The TopologyChart object returned by New-AbrTopologyDiagram (or a previous Add-AbrTopology* call).
    .PARAMETER OutputFolderPath
        Folder the rendered file will be written to.
    .PARAMETER Filename
        Output file name, without extension.
    .PARAMETER Format
        Output format. Supported formats are svg, png, html, bmp, gif, tiff, ppm, apng, and base64.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Please provide the diagram returned by New-AbrTopologyDiagram')]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyChart] $Diagram,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the folder the rendered file will be written to')]
        [ValidateScript( {
                if (Test-Path -Path $_) {
                    $true
                } else {
                    throw "Folder $_ not found!"
                }
            })]
        [string] $OutputFolderPath,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the output file name, without extension')]
        [ValidateNotNullOrEmpty()]
        [string] $Filename,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the output format (svg, png, html, bmp, gif, tiff, ppm, apng, base64)')]
        [ValidateSet('svg', 'png', 'html', 'bmp', 'gif', 'tiff', 'ppm', 'apng', 'base64')]
        [Array] $Format = @('svg')
    )

    process {
        try {
            # Format is typed as [Array] (rather than [string]) so a single-element array such as
            # @('svg') - the convention used throughout this module's Export-* Format parameters -
            # binds cleanly; only the first requested format is honored.
            $SelectedFormat = @($Format)[0]

            if ($SelectedFormat -eq 'base64') {
                $TempFile = Export-TopologyChart -Chart $Diagram -OutputFolderPath $OutputFolderPath -Filename "$($Filename)_temp" -Format 'png'
                return ConvertTo-Base64 -ImageInput $TempFile.FullName -Delete $true
            }

            Export-TopologyChart -Chart $Diagram -OutputFolderPath $OutputFolderPath -Filename $Filename -Format $SelectedFormat
        } catch {
            Write-Error "Failed to export ChartForgeX topology diagram: $($_.Exception.Message)"
        }
    }
}
