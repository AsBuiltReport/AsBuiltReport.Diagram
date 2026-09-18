function Add-AbrTopologyNode {
    <#
    .SYNOPSIS
        Adds a node to a ChartForgeX-backed topology diagram.
    .DESCRIPTION
        Part of the ChartForgeX DSL (see New-AbrTopologyDiagram). Supports plain nodes, built-in
        icon shapes (-IconShape) and custom image icons (-IconPath, base64-encoded as a data: URI).
    .EXAMPLE
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -Kind Server -Status Healthy
    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .PARAMETER Diagram
        The TopologyChart object returned by New-AbrTopologyDiagram (or a previous Add-AbrTopology* call).
    .PARAMETER Id
        Unique identifier for the node.
    .PARAMETER Label
        Display label for the node.
    .PARAMETER X
        X coordinate. Ignored by auto layout modes.
    .PARAMETER Y
        Y coordinate. Ignored by auto layout modes.
    .PARAMETER Kind
        Semantic node kind (Server, Database, Cloud, etc.).
    .PARAMETER Status
        Health status badge.
    .PARAMETER GroupId
        Identifier of the group/cluster this node belongs to.
    .PARAMETER Subtitle
        Secondary line of text under the label.
    .PARAMETER Href
        Hyperlink applied to the node in HTML/SVG output.
    .PARAMETER Tooltip
        Tooltip text shown on hover.
    .PARAMETER Width
        Node width in pixels.
    .PARAMETER Height
        Node height in pixels.
    .PARAMETER Symbol
        Short symbol/abbreviation rendered inside built-in icon shapes.
    .PARAMETER CssClass
        CSS class applied to the node in HTML/SVG output.
    .PARAMETER Color
        Foreground/accent color (hex).
    .PARAMETER BackgroundColor
        Background fill color (hex).
    .PARAMETER IconShape
        Built-in renderer icon shape hint, e.g. Server, Database, Cloud.
    .PARAMETER IconPath
        Path to a custom icon image file. It is embedded as a base64 data: URI.
    .PARAMETER DisplayMode
        Node display mode (Card, Icon, Artwork, Pill, Dot, Hidden, etc.). Defaults to 'Card' when
        -IconPath is used so the node label remains visible alongside the custom icon.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [CmdletBinding()]
    [OutputType([ChartForgeX.Topology.TopologyChart])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Please provide the diagram returned by New-AbrTopologyDiagram')]
        [ValidateNotNullOrEmpty()]
        [ChartForgeX.Topology.TopologyChart] $Diagram,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide a unique identifier for the node')]
        [ValidateNotNullOrEmpty()]
        [string] $Id,

        [Parameter(Mandatory = $true, HelpMessage = 'Please provide the display label for the node')]
        [ValidateNotNullOrEmpty()]
        [string] $Label,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the X coordinate')]
        [double] $X,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the Y coordinate')]
        [double] $Y,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the semantic node kind (Server, Database, Cloud, etc.)')]
        [ChartForgeX.Topology.TopologyNodeKind] $Kind = [ChartForgeX.Topology.TopologyNodeKind]::Generic,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the health status badge')]
        [ChartForgeX.Topology.TopologyHealthStatus] $Status = [ChartForgeX.Topology.TopologyHealthStatus]::Unknown,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the identifier of the group/cluster this node belongs to')]
        [string] $GroupId,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide a secondary line of text under the label')]
        [string] $Subtitle,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the hyperlink applied to the node in HTML/SVG output')]
        [string] $Href,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the tooltip text shown on hover')]
        [string] $Tooltip,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the node width in pixels')]
        [double] $Width = 150,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the node height in pixels')]
        [double] $Height = 64,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the short symbol/abbreviation rendered inside built-in icon shapes')]
        [string] $Symbol,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the CSS class applied to the node in HTML/SVG output')]
        [string] $CssClass,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the foreground/accent color (hex)')]
        [string] $Color,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the background fill color (hex)')]
        [string] $BackgroundColor,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the built-in renderer icon shape hint, e.g. Server, Database, Cloud')]
        [ChartForgeX.Topology.TopologyIconShape] $IconShape,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the path to a custom icon image file')]
        [ValidateScript( {
                if (Test-Path -Path $_) {
                    $true
                } else {
                    throw "File $_ not found!"
                }
            })]
        [System.IO.FileInfo] $IconPath,

        [Parameter(Mandatory = $false, HelpMessage = 'Please provide the node display mode (Card, Icon, Artwork, Pill, Dot, Hidden, etc.)')]
        [ChartForgeX.Topology.TopologyNodeDisplayMode] $DisplayMode
    )

    process {
        try {
            $Params = @{
                Chart  = $Diagram
                Id     = $Id
                Label  = $Label
                X      = $X
                Y      = $Y
                Kind   = $Kind
                Status = $Status
                Width  = $Width
                Height = $Height
            }
            if ($GroupId) { $Params.GroupId = $GroupId }
            if ($Subtitle) { $Params.Subtitle = $Subtitle }
            if ($Href) { $Params.Href = $Href }
            if ($Tooltip) { $Params.Tooltip = $Tooltip }
            if ($Symbol) { $Params.Symbol = $Symbol }
            if ($CssClass) { $Params.CssClass = $CssClass }
            if ($Color) { $Params.Color = $Color }
            if ($BackgroundColor) { $Params.BackgroundColor = $BackgroundColor }
            if ($PSBoundParameters.ContainsKey('DisplayMode')) { $Params.DisplayMode = $DisplayMode }

            if ($IconPath) {
                $MimeType = switch ([System.IO.Path]::GetExtension($IconPath).TrimStart('.').ToLowerInvariant()) {
                    'jpg' { 'image/jpeg' }
                    'jpeg' { 'image/jpeg' }
                    'svg' { 'image/svg+xml' }
                    'gif' { 'image/gif' }
                    'bmp' { 'image/bmp' }
                    default { 'image/png' }
                }
                $Base64 = ConvertTo-Base64 -ImageInput $IconPath -Delete $false
                $Params.IconHref = "data:$($MimeType);base64,$($Base64)"
            } elseif ($PSBoundParameters.ContainsKey('IconShape')) {
                $Params.IconShape = $IconShape
            }

            Add-TopologyNode @Params
        } catch {
            Write-Error "Failed to add ChartForgeX topology node: $($_.Exception.Message)"
        }
    }
}
