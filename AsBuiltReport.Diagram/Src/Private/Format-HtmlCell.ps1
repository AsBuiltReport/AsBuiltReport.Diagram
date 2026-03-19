function Format-HtmlCell {
    <#
    .SYNOPSIS
        Dynamically builds Graphviz HTML table cell (<TR><TD>) markup from structured input.

    .DESCRIPTION
        Accepts a Hashtable, OrderedDictionary, PSCustomObject, or string array and converts
        each entry into one or more <TR><TD>...</TD></TR> rows. The resulting string is ready
        to be passed directly to Format-HtmlTable as the -TableRowContent parameter, or
        embedded in any Graphviz HTML label.

        Input type behaviour:
          - Hashtable / OrderedDictionary : each key-value pair becomes one row rendered as "Key: Value".
          - PSCustomObject                : each property becomes one row rendered as "Name: Value".
          - string[]                      : each string becomes one single-cell row.

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

    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux

    .PARAMETER Rows
        The input data to convert into table cells. Accepts Hashtable, OrderedDictionary,
        PSCustomObject, or a string array.

    .PARAMETER Align
        Horizontal alignment of cell content. Accepted values: 'Center', 'Left', 'Right'.
        Default is 'Center'.

    .PARAMETER CellBackgroundColor
        Background color of each <TD> cell (hex or named color). Default is '#FFFFFF'.

    .PARAMETER CellBorder
        Width of the HTML cell border. Default is 0.

    .PARAMETER CellPadding
        Padding inside each cell. Default is 5.

    .PARAMETER ColSpan
        Number of columns each cell should span. Default is 1.

    .PARAMETER FontBold
        Renders cell text in bold.

    .PARAMETER FontColor
        Font color (hex or named color). Default is '#000000'.

    .PARAMETER FontItalic
        Renders cell text in italic.

    .PARAMETER FontName
        Font face name. Default is 'Segoe Ui'.

    .PARAMETER FontOverline
        Renders cell text with an overline.

    .PARAMETER FontSize
        Font size in points. Default is 14.

    .PARAMETER FontStrikeThrough
        Renders cell text with a strikethrough.

    .PARAMETER FontSubscript
        Renders cell text as subscript.

    .PARAMETER FontSuperscript
        Renders cell text as superscript.

    .PARAMETER FontUnderline
        Renders cell text with underline.

    .PARAMETER IconDebug
        When $true, highlights each cell with a red background for layout debugging.
        Aliased as DraftMode.

    .PARAMETER Port
        Graphviz port name attached to each cell via the PORT attribute. Default is 'EdgeDot'.
    #>

    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory,
            HelpMessage = 'Input data: Hashtable, OrderedDictionary, PSCustomObject, or string array.'
        )]
        [Alias('InputObject')]
        $Rows,

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
