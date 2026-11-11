function Add-HtmlSubGraph {
    <#
    .SYNOPSIS
        Function to convert a array to a HTML Table to mimic Graphviz Cluster (Subgraph).
    .DESCRIPTION
        Takes a array and converts it to a HTML table to mimic Graphviz Subgraph
    .Example
        $SiteSubnets = @("192.68.5.0/24", "192.68.7.0/24", "10.0.0.0/24")
        Add-HtmlSubGraph -TableArray $SiteSubnets -Align "Center" -ColumnSize 2
            _________________________________
            |               |               |
            |192.168.5.0/24 |192.168.7.0/24 |
            ________________________________
            |               |               |
            |  10.0.0.0/24  |               |
            _________________________________

        $SiteSubnets = @("192.68.5.0/24", "192.68.7.0/24", "10.0.0.0/24")
        Add-HtmlSubGraph -TableArray $SiteSubnets -Align "Center"
            _________________
            |               |
            |192.168.5.0/24 |
            _________________
            |               |
            |192.168.7.0/24 |
            _________________
            |               |
            |  10.0.0.0/24  |
            _________________

    .NOTES
        Version:        0.2.36
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux

    .PARAMETER TableArray
        An array of strings/objects to place in this record
    .PARAMETER ImagesObj
        Hashtable with the IconName > IconPath translation
    .PARAMETER ImageSizePercent
        Set the image size in percent (Default: 100)
    .PARAMETER Align
        Align content inside table cell (Default: Center)
    .PARAMETER TableBorder
        The table border width (Default: 0)
    .PARAMETER CellBorder
        The table cell border width (Default: 0)
    .PARAMETER CellPadding
        The table cell padding space (Default: 5)
    .PARAMETER CellSpacing
        The table cell spacing (Default: 5)
    .PARAMETER FontSize
        The text font size used inside the cell (Default: 14)
    .PARAMETER FontName
        The text font name used inside the cell (Default: Segoe Ui)
    .PARAMETER FontColor
        The text font color used inside the cell (Default: #000000)
    .PARAMETER FontBold
        Make the label text bold.
    .PARAMETER FontItalic
        Make the label text italic.
    .PARAMETER FontUnderline
        Underline the label text.
    .PARAMETER FontOverline
        Add an overline to the label text.
    .PARAMETER FontSubscript
        Format the label text as subscript.
    .PARAMETER FontSuperscript
        Format the label text as superscript.
    .PARAMETER FontStrikeThrough
        Strike through the label text.
    .PARAMETER ColumnSize
        Number used to split objects inside the HTML table (Default: 1)
    .PARAMETER IconDebug
        Enable debug rendering for the icon.
    .PARAMETER NoFontBold
        Disable additional bold formatting.
    .PARAMETER IconType
        The subgraph table icon type
    .PARAMETER Label
        The subgraph table label
    .PARAMETER LabelPos
        The subgraph table label position (top or down, Default: down)
    .PARAMETER TableStyle
        Table style (ROUNDED, RADIAL, SOLID, INVISIBLE, INVIS, DOTTED, DASHED)
    .PARAMETER TableBorderColor
        The subgraph table border color (Default: #000000)
    .PARAMETER TableBackgroundColor
        The subgraph table background color (Default: #ffffff)
    .PARAMETER IconWidth
        The subgraph icon width (Default: 40)
    .PARAMETER IconHeight
        The subgraph icon height (Default: 40)
    .PARAMETER IconPath
        Path to the directory containing the icon image, required when ImageSizePercent is less than 100.
    .PARAMETER Name
        Name for the generated node object (required for every invocation).
    .PARAMETER NodeObject
        Return a Graphviz node object instead of the HTML table string.
    .PARAMETER GraphvizAttributes
        Additional Graphviz attributes to apply when returning a node object.
    #>

    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'The table array to process'
        )]
        [string[]] $TableArray,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Please provide the Image Hashtable Object'
        )]
        [Hashtable] $ImagesObj,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Set the image size in percent (100% is default)'
        )]
        [ValidateRange(1, 100)]
        [int] $ImageSizePercent = 100,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the text align'
        )]
        [string] $Align = 'Center',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the width of the html table border'
        )]
        [int] $TableBorder = 0,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the width of the html cell border'
        )]
        [int] $CellBorder = 0,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the padding of the html cell border'
        )]
        [int] $CellPadding = 5,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the spacing of the html cell border'
        )]
        [int] $CellSpacing = 5,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The cell text font size'
        )]
        [int] $FontSize = 14,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The cell text font name'
        )]
        [string] $FontName = 'Segoe Ui',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The cell text font color'
        )]
        [string] $FontColor = '#000000',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the font bold'
        )]
        [switch] $FontBold,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the font italic'
        )]
        [switch] $FontItalic,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the font underline'
        )]
        [switch] $FontUnderline,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the font overline'
        )]
        [switch] $FontOverline,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the font subscript'
        )]
        [switch] $FontSubscript,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the font superscript'
        )]
        [switch] $FontSuperscript,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the font strikethrough'
        )]
        [switch] $FontStrikeThrough,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'This value is used to specified a int used to split the object inside the HTML table'
        )]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ColumnSize = 1,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Enable the icon debug mode'
        )]
        [Alias('DraftMode')]
        [bool] $IconDebug,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Disable the aditional text bold configuration'
        )]
        [Switch] $NoFontBold,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the subgraph table icon'
        )]
        [ValidateScript({
                if ($ImagesObj) {
                    $true
                } else {
                    throw 'ImagesObj table needed if IconType option is especified.'
                }
            })]
        [string]$IconType,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the subgraph table label'
        )]
        [string]$Label,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the subgraph table label position (top, down)'
        )]
        [ValidateSet('top', 'down')]
        [string]$LabelPos = 'down',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set a table style (ROUNDED, RADIAL, SOLID, INVISIBLE, INVIS, DOTTED, and DASHED)'
        )]
        [string]$TableStyle = 'SOLID',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set a table border color'
        )]
        [string]$TableBorderColor = '#000000',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set a table border color'
        )]
        [string]$TableBackgroundColor = '#ffffff',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set a subgraph icon width'
        )]
        [int] $IconWidth = 40,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set a subgraph icon height'
        )]
        [int] $IconHeight = 40,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Path to the directory containing icon image files'
        )]
        [string] $IconPath,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specifies the name of the node.'
        )]
        [String]$Name,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Allow to set the text align'
        )]
        [ValidateScript({
                if ($Name) {
                    $true
                } else {
                    throw 'Name parameter is required when NodeObject is set.'
                }
            })]
        [switch] $NodeObject,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Additional Graphviz attributes to add to the node (e.g., style=filled,color=lightgrey)'
        )]
        [hashtable] $GraphvizAttributes = @{}
    )

    if ($ImagesObj -and $ImagesObj[$IconType]) {
        $Icon = $ImagesObj[$IconType]
    } else { $Icon = $null }

    # Set the image size if ImageSizePercent is less than 100
    if ($Icon -and $ImageSizePercent -lt 100) {
        if (-not $IconPath) {
            throw 'IconPath is required when ImageSizePercent is less than 100.'
        }
        $ImageSize = Get-ImagePercent -ImageInput (Join-Path -Path $IconPath -Child $Icon) -Percent $ImageSizePercent
        $IconWidth = $ImageSize.Width
        $IconHeight = $ImageSize.Height
    }

    if ($TableArray.Count -le 1) {
        $Group = $TableArray
    } else {
        $Group = Split-ArrayElement -inArray $TableArray -size $ColumnSize
    }

    $Number = 0
    $TD = ''
    $TR = ''
    $CellFontOpen = if ($FontName -eq 'Segoe Ui' -and $FontColor -eq '#000000') {
        '<FONT POINT-SIZE="{0}">'
    } else {
        '<FONT FACE="{0}" POINT-SIZE="{1}" COLOR="{2}">'
    }
    while ($Number -ne $Group.Count) {
        foreach ($Element in $Group[$Number]) {
            if ($FontName -eq 'Segoe Ui' -and $FontColor -eq '#000000') {
                $CellFont = $CellFontOpen -f $FontSize
            } else {
                $CellFont = $CellFontOpen -f $FontName, $FontSize, $FontColor
            }
            $TD += '<TD align="{0}" colspan="1">{1}{2}</FONT></TD>' -f $Align, $CellFont, $Element
        }
        $TR += '<TR>{0}</TR>' -f $TD
        $TD = ''
        $Number++
    }

    $fontParams = @{
        FontSize = $FontSize
        FontColor = $FontColor
        FontBold = $FontBold
        FontItalic = $FontItalic
        FontUnderline = $FontUnderline
        FontName = $FontName
        FontSubscript = $FontSubscript
        FontSuperscript = $FontSuperscript
        FontStrikeThrough = $FontStrikeThrough
        FontOverline = $FontOverline
    }
    $FormattedLabel = ''
    if (-not [string]::IsNullOrWhiteSpace($Label)) {
        $FormattedLabel = Format-HtmlFontProperty @fontParams -Text $Label
    }
    $ColumnCount = [Math]::Min($TableArray.Count, $ColumnSize)

    # Build subgraph icon/label rows and prepend or append based on LabelPos
    $TRTemp = ''
    if ($Icon) {
        if ($IconDebug) {
            $TDSubgraphIcon = '<TD bgcolor="#FFCCCC" ALIGN="{0}" colspan="{1}"><FONT FACE="{2}" Color="{3}" POINT-SIZE="{4}">{5}</FONT></TD>' -f $Align, $ColumnCount, $FontName, $FontColor, $FontSize, $Icon
            $TDSubgraph = '<TD ALIGN="{0}" colspan="{1}">{2}</TD>' -f $Align, $ColumnCount, $FormattedLabel
        } else {
            $TDSubgraphIcon = '<TD valign="BOTTOM" ALIGN="{0}" colspan="{1}" fixedsize="true" width="{3}" height="{4}"><IMG src="{2}"></IMG></TD>' -f $Align, $ColumnCount, $Icon, $IconWidth, $IconHeight
            $TDSubgraph = '<TD valign="TOP" ALIGN="{0}" colspan="{1}">{2}</TD>' -f $Align, $ColumnCount, $FormattedLabel
        }
        if ($LabelPos -eq 'down') {
            $TR += '<TR>{0}</TR>' -f $TDSubgraphIcon
            if ($FormattedLabel) {
                $TR += '<TR>{0}</TR>' -f $TDSubgraph
            }
        } else {
            $TRTemp += '<TR>{0}</TR>' -f $TDSubgraphIcon
            if ($FormattedLabel) {
                $TRTemp += '<TR>{0}</TR>' -f $TDSubgraph
            }
            $TRTemp += $TR
            $TR = $TRTemp
        }
    } else {
        if ($FormattedLabel) {
            $TDSubgraph = '<TD ALIGN="{0}" colspan="{1}">{2}</TD>' -f $Align, $ColumnCount, $FormattedLabel
            if ($LabelPos -eq 'down') {
                $TR += '<TR>{0}</TR>' -f $TDSubgraph
            } else {
                $TRTemp = '<TR>{0}</TR>' -f $TDSubgraph
                $TRTemp += $TR
                $TR = $TRTemp
            }
        }
    }

    $tableParams = @{
        TableStyle = $TableStyle
        TableBackgroundColor = $TableBackgroundColor
        CellSpacing = $CellSpacing
        CellPadding = $CellPadding
        TableRowContent = $TR
    }
    if ($IconDebug) {
        $tableParams.TableBorderColor = 'red'
        $tableParams.TableBorder = 1
        $tableParams.CellBorder = 1
    } else {
        $tableParams.TableBorderColor = $TableBorderColor
        $tableParams.TableBorder = $TableBorder
        $tableParams.CellBorder = $CellBorder
    }
    $HTML = Format-HtmlTable @tableParams
    Format-NodeObject -Name $Name -HtmlObject $HTML -GraphvizAttributes $GraphvizAttributes -AsHtml:(-not $NodeObject)
}