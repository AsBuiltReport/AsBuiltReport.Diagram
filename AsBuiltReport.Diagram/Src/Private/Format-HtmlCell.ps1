function Format-HtmlCell {
    <#
    .SYNOPSIS
        Dynamically builds Graphviz HTML table cell (<TR><TD>) markup from structured input or an image source.

    .DESCRIPTION
        Accepts a Hashtable, OrderedDictionary, PSCustomObject, or string array and converts
        each entry into one or more <TR><TD>...</TD></TR> rows. The resulting string is ready
        to be passed directly to Format-HtmlTable as the -TableRowContent parameter, or
        embedded in any Graphviz HTML label.

        Input type behaviour (Text parameter set):
          - Hashtable / OrderedDictionary : each key-value pair becomes one row rendered as "Key: Value".
          - PSCustomObject                : each property becomes one row rendered as "Name: Value".
          - string[]                      : each string becomes one single-cell row.

        When the Image parameter set is used (i.e. -ImageSrc is supplied), the function produces
        a fixed-size or auto-sized image cell:
          '<TR><TD STYLE="..." ALIGN="..." fixedsize="true" width="..." height="..." colspan="1"><img src="..."/></TD></TR>'
        or, without -FixedSize:
          '<TR><TD STYLE="..." ALIGN="..." colspan="1"><img src="..."/></TD></TR>'

    .EXAMPLE
        # Build cell markup from a hashtable and wrap it in a table
        $cells = Format-HtmlCell -Rows @{ OS = 'Windows'; Version = '2019' }
        $table = Format-HtmlTable -TableRowContent $cells
        Node 'MyServer' @{ label = $table; shape = 'plain' }

    .EXAMPLE
        # Build cell markup from a PSCustomObject
        $info = [PSCustomObject][ordered]@{ CPU = '8 vCPU'; RAM = '32 GB' }
        $cells = Format-HtmlCell -Rows $info -FontBold -CellBackgroundColor '#EEF2FF'
        Format-HtmlTable -TableRowContent $cells

    .EXAMPLE
        # Build a two-column flat list from a string array
        Format-HtmlCell -Rows @('192.168.1.0/24', '10.0.0.0/8') -Align 'Left' -FontSize 12

    .EXAMPLE
        # Build an auto-sized image cell
        Format-HtmlCell -ImageSrc '/icons/server.png' -CellStyle SOLID

    .EXAMPLE
        # Build a fixed-size image cell
        Format-HtmlCell -ImageSrc '/icons/server.png' -CellStyle ROUNDED -FixedSize -Width 48 -Height 48

    .NOTES
        Version:        0.2.0
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux

    .PARAMETER Rows
        The input data to convert into table cells. Accepts Hashtable, OrderedDictionary,
        PSCustomObject, or a string array. Used in the Text parameter set.

    .PARAMETER ImageSrc
        Path to the image file to embed as an <img> element inside the TD cell.
        Selects the Image parameter set.

    .PARAMETER CellStyle
        STYLE attribute applied to the TD cell when using the Image parameter set.
        Accepted values: ROUNDED, RADIAL, SOLID, INVISIBLE, INVIS, DOTTED, DASHED.
        Default is 'SOLID'.

    .PARAMETER FixedSize
        When set, applies fixedsize="true" together with -Width and -Height to the TD cell.
        Only valid in the Image parameter set.

    .PARAMETER Width
        Cell width in pixels. Requires -FixedSize. Only valid in the Image parameter set.

    .PARAMETER Height
        Cell height in pixels. Requires -FixedSize. Only valid in the Image parameter set.

    .PARAMETER Align
        Horizontal alignment of cell content. Accepted values: 'Center', 'Left', 'Right'.
        Default is 'Center'.

    .PARAMETER CellBackgroundColor
        Background color of each <TD> cell (hex or named color). Default is '#FFFFFF'.
        Only used in the Text parameter set.

    .PARAMETER CellBorder
        Width of the HTML cell border. Default is 0. Only used in the Text parameter set.

    .PARAMETER CellPadding
        Padding inside each cell. Default is 5. Only used in the Text parameter set.

    .PARAMETER ColSpan
        Number of columns each cell should span. Default is 1.

    .PARAMETER FontBold
        Renders cell text in bold. Only used in the Text parameter set.

    .PARAMETER FontColor
        Font color (hex or named color). Default is '#000000'. Only used in the Text parameter set.

    .PARAMETER FontItalic
        Renders cell text in italic. Only used in the Text parameter set.

    .PARAMETER FontName
        Font face name. Default is 'Segoe Ui'. Only used in the Text parameter set.

    .PARAMETER FontOverline
        Renders cell text with an overline. Only used in the Text parameter set.

    .PARAMETER FontSize
        Font size in points. Default is 14. Only used in the Text parameter set.

    .PARAMETER FontStrikeThrough
        Renders cell text with a strikethrough. Only used in the Text parameter set.

    .PARAMETER FontSubscript
        Renders cell text as subscript. Only used in the Text parameter set.

    .PARAMETER FontSuperscript
        Renders cell text as superscript. Only used in the Text parameter set.

    .PARAMETER FontUnderline
        Renders cell text with underline. Only used in the Text parameter set.

    .PARAMETER IconDebug
        When $true, highlights each cell with a red background (Text) or renders the image
        source path as plain text (Image) for layout debugging. Aliased as DraftMode.

    .PARAMETER Port
        Graphviz port name attached to each cell via the PORT attribute. Default is 'EdgeDot'.
        Only used in the Text parameter set.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Text')]
    [OutputType([System.String])]
    param(
        [Parameter(
            ParameterSetName = 'Text',
            Mandatory,
            HelpMessage = 'Input data: Hashtable, OrderedDictionary, PSCustomObject, or string array.'
        )]
        [Alias('InputObject')]
        $Rows,

        [Parameter(
            ParameterSetName = 'Image',
            Mandatory,
            HelpMessage = 'Path to the image file to embed as an <img> element.'
        )]
        [string] $ImageSrc,

        [Parameter(
            ParameterSetName = 'Image',
            Mandatory = $false,
            HelpMessage = 'STYLE attribute applied to the TD cell.'
        )]
        [ValidateSet('ROUNDED', 'RADIAL', 'SOLID', 'INVISIBLE', 'INVIS', 'DOTTED', 'DASHED')]
        [string] $CellStyle = 'SOLID',

        [Parameter(
            ParameterSetName = 'Image',
            Mandatory = $false,
            HelpMessage = 'Applies fixedsize="true" with the given Width and Height to the TD cell.'
        )]
        [switch] $FixedSize,

        [Parameter(
            ParameterSetName = 'Image',
            Mandatory = $false,
            HelpMessage = 'Cell width in pixels. Requires -FixedSize.'
        )]
        [int] $Width,

        [Parameter(
            ParameterSetName = 'Image',
            Mandatory = $false,
            HelpMessage = 'Cell height in pixels. Requires -FixedSize.'
        )]
        [int] $Height,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Horizontal alignment of cell content.'
        )]
        [ValidateSet('Center', 'Left', 'Right')]
        [string] $Align = 'Center',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Background color of each TD cell.'
        )]
        [string] $CellBackgroundColor = '#FFFFFF',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Width of the HTML cell border.'
        )]
        [int] $CellBorder = 0,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Padding inside each cell.'
        )]
        [int] $CellPadding = 5,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Number of columns each cell should span.'
        )]
        [int] $ColSpan = 1,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Renders cell text in bold.'
        )]
        [switch] $FontBold,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Font color (hex or named color).'
        )]
        [string] $FontColor = '#000000',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Renders cell text in italic.'
        )]
        [switch] $FontItalic,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Font face name.'
        )]
        [string] $FontName = 'Segoe Ui',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Renders cell text with an overline.'
        )]
        [switch] $FontOverline,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Font size in points.'
        )]
        [int] $FontSize = 14,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Renders cell text with a strikethrough.'
        )]
        [switch] $FontStrikeThrough,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Renders cell text as subscript.'
        )]
        [switch] $FontSubscript,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Renders cell text as superscript.'
        )]
        [switch] $FontSuperscript,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Renders cell text with underline.'
        )]
        [switch] $FontUnderline,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Highlights cells in red for layout debugging.'
        )]
        [Alias('DraftMode')]
        [bool] $IconDebug = $false,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Graphviz port name attached to each cell via the PORT attribute.'
        )]
        [string] $Port = 'EdgeDot'
    )

    $debugBg = if ($IconDebug) { '#FFCCCC' } else { $CellBackgroundColor }

    $tr = [System.Text.StringBuilder]::new()

    # Build a single <TR><TD>...</TD></TR> string using concatenation to avoid any
    # ambiguity between HTML attribute quotes and PowerShell's -f format operator.
    function buildTD ([string]$tdPort, [string]$tdBg, [string]$tdAlign, [int]$tdSpan, [int]$tdPad, [int]$tdBorder, [string]$tdContent) {
        return '<TR><TD PORT="' + $tdPort + '" BGCOLOR="' + $tdBg + '" ALIGN="' + $tdAlign + '" COLSPAN="' + $tdSpan + '" CELLPADDING="' + $tdPad + '" BORDER="' + $tdBorder + '">' + $tdContent + '</TD></TR>'
    }

    # Build an image <TR><TD><img .../></TD></TR> cell.
    function buildImgTD ([string]$tdStyle, [string]$tdAlign, [int]$tdSpan, [string]$tdSrc, [bool]$fixed, [int]$w, [int]$h) {
        if ($fixed) {
            return '<TR><TD STYLE="' + $tdStyle + '" ALIGN="' + $tdAlign + '" fixedsize="true" width="' + $w + '" height="' + $h + '" colspan="' + $tdSpan + '"><img src="' + $tdSrc + '"/></TD></TR>'
        } else {
            return '<TR><TD STYLE="' + $tdStyle + '" ALIGN="' + $tdAlign + '" colspan="' + $tdSpan + '"><img src="' + $tdSrc + '"/></TD></TR>'
        }
    }

    # Image parameter set: emit a single image cell and return early.
    if ($PSCmdlet.ParameterSetName -eq 'Image') {
        if ($IconDebug) {
            [void]$tr.Append('<TR><TD STYLE="SOLID" ALIGN="' + $Align + '" colspan="' + $ColSpan + '">' + $ImageSrc + '</TD></TR>')
        } else {
            [void]$tr.Append((buildImgTD $CellStyle $Align $ColSpan $ImageSrc ([bool]$FixedSize) $Width $Height))
        }
        return $tr.ToString()
    }

    switch ($Rows.GetType().Name) {
        'Hashtable' {
            foreach ($entry in $Rows.GetEnumerator()) {
                $label = $entry.Key + ': ' + $entry.Value
                $text = Format-HtmlFontProperty -Text $label -FontSize $FontSize -FontColor $FontColor -FontName $FontName -FontBold:$FontBold -FontItalic:$FontItalic -FontUnderline:$FontUnderline -FontOverline:$FontOverline -FontSubscript:$FontSubscript -FontSuperscript:$FontSuperscript -FontStrikeThrough:$FontStrikeThrough
                [void]$tr.Append((buildTD $entry.Key $debugBg $Align $ColSpan $CellPadding $CellBorder $text))
            }
        }

        'OrderedDictionary' {
            foreach ($entry in $Rows.GetEnumerator()) {
                $label = $entry.Key + ': ' + $entry.Value
                $text = Format-HtmlFontProperty -Text $label -FontSize $FontSize -FontColor $FontColor -FontName $FontName -FontBold:$FontBold -FontItalic:$FontItalic -FontUnderline:$FontUnderline -FontOverline:$FontOverline -FontSubscript:$FontSubscript -FontSuperscript:$FontSuperscript -FontStrikeThrough:$FontStrikeThrough
                [void]$tr.Append((buildTD $entry.Key $debugBg $Align $ColSpan $CellPadding $CellBorder $text))
            }
        }

        'PSCustomObject' {
            foreach ($prop in $Rows.PSObject.Properties) {
                $label = $prop.Name + ': ' + $prop.Value
                $text = Format-HtmlFontProperty -Text $label -FontSize $FontSize -FontColor $FontColor -FontName $FontName -FontBold:$FontBold -FontItalic:$FontItalic -FontUnderline:$FontUnderline -FontOverline:$FontOverline -FontSubscript:$FontSubscript -FontSuperscript:$FontSuperscript -FontStrikeThrough:$FontStrikeThrough
                [void]$tr.Append((buildTD $prop.Name $debugBg $Align $ColSpan $CellPadding $CellBorder $text))
            }
        }

        default {
            # string[] or any other enumerable
            foreach ($item in @($Rows)) {
                $text = Format-HtmlFontProperty -Text ([string]$item) -FontSize $FontSize -FontColor $FontColor -FontName $FontName -FontBold:$FontBold -FontItalic:$FontItalic -FontUnderline:$FontUnderline -FontOverline:$FontOverline -FontSubscript:$FontSubscript -FontSuperscript:$FontSuperscript -FontStrikeThrough:$FontStrikeThrough
                [void]$tr.Append((buildTD $Port $debugBg $Align $ColSpan $CellPadding $CellBorder $text))
            }
        }
    }

    return $tr.ToString()
}
