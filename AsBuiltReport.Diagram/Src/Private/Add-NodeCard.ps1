function Add-NodeCard {
    <#
    .SYNOPSIS
        Creates a Graphviz HTML-like card node.

    .DESCRIPTION
        Creates a Graphviz HTML table that visually matches a ChartForgeX Card node: an optional
        icon, a title, an optional subtitle, and optional metadata rows. Use -NodeObject to add
        the card directly to the current PSGraph graph.

    .EXAMPLE
        Add-NodeCard -Name 'Web01' -Label 'Web-Server-01' -Subtitle 'Red Hat Linux 10' -IconPath ./Icons/Server.png -AdditionalInfo @{ IP = '10.0.0.1' } -NodeObject
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory, HelpMessage = 'The Graphviz node name.')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory, HelpMessage = 'The card title.')]
        [ValidateNotNullOrEmpty()]
        [string] $Label,

        [Parameter(HelpMessage = 'Secondary text displayed below the card title.')]
        [string] $Subtitle,

        [Parameter(HelpMessage = 'Path to the icon displayed on the left of the card title.')]
        [ValidateScript({
                if (Test-Path -Path $_ -PathType Leaf) {
                    $true
                } else {
                    throw "Icon file '$_' was not found."
                }
            })]
        [System.IO.FileInfo] $IconPath,

        [Parameter(HelpMessage = 'A hashtable, ordered dictionary, PSCustomObject, or array containing metadata rows.')]
        [Alias('AditionalInfo', 'Rows', 'RowsOrdered')]
        $AdditionalInfo,

        [Parameter(HelpMessage = 'The card title font size.')]
        [ValidateRange(1, 100)]
        [int] $FontSize = 14,

        [Parameter(HelpMessage = 'The card subtitle font size.')]
        [ValidateRange(1, 100)]
        [int] $SubtitleFontSize = 11,

        [Parameter(HelpMessage = 'The card font name.')]
        [string] $FontName = 'Segoe Ui',

        [Parameter(HelpMessage = 'The card text color.')]
        [string] $FontColor = '#000000',

        [Parameter(HelpMessage = 'The card background color.')]
        [string] $BackgroundColor = '#FFFFFF',

        [Parameter(HelpMessage = 'The card border color.')]
        [string] $BorderColor = '#71797E',

        [Parameter(HelpMessage = 'The card border width.')]
        [ValidateRange(0, 100)]
        [int] $Border = 1,

        [Parameter(HelpMessage = 'The padding inside card cells.')]
        [ValidateRange(0, 100)]
        [int] $CellPadding = 8,

        [Parameter(HelpMessage = 'The named port for edges attached to the card.')]
        [ValidateNotNullOrEmpty()]
        [string] $Port = 'EdgeDot',

        [Parameter(HelpMessage = 'Registers the card as a PSGraph node instead of returning HTML markup.')]
        [switch] $NodeObject,

        [Parameter(HelpMessage = 'Additional Graphviz attributes used when -NodeObject is specified.')]
        [hashtable] $GraphvizAttributes = @{}
    )

    process {
        $escape = [System.Security.SecurityElement]::Escape
        $escapedLabel = $escape.Invoke($Label)
        $title = '<FONT FACE="{0}" COLOR="{1}" POINT-SIZE="{2}"><B>{3}</B></FONT>' -f $escape.Invoke($FontName), $escape.Invoke($FontColor), $FontSize, $escapedLabel
        $subtitleMarkup = if ([string]::IsNullOrWhiteSpace($Subtitle)) {
            ''
        } else {
            '<BR/><FONT FACE="{0}" COLOR="{1}" POINT-SIZE="{2}">{3}</FONT>' -f $escape.Invoke($FontName), $escape.Invoke($FontColor), $SubtitleFontSize, $escape.Invoke($Subtitle)
        }

        $iconCell = if ($IconPath) {
            '<TD ALIGN="CENTER" VALIGN="MIDDLE"><IMG SRC="{0}"/></TD>' -f $escape.Invoke($IconPath.FullName)
        } else {
            ''
        }
        $columnCount = if ($IconPath) { 2 } else { 1 }
        $rows = '<TR>{0}<TD ALIGN="LEFT" VALIGN="MIDDLE">{1}{2}</TD></TR>' -f $iconCell, $title, $subtitleMarkup

        foreach ($item in @($AdditionalInfo)) {
            if ($null -eq $item) {
                continue
            }

            $entries = if ($item -is [System.Collections.IDictionary]) {
                $item.GetEnumerator()
            } elseif ($item -is [psobject]) {
                $item.PSObject.Properties | Where-Object { $_.MemberType -in 'NoteProperty', 'Property' }
            } else {
                throw "AdditionalInfo item '$item' must be a dictionary or object with properties."
            }

            foreach ($entry in $entries) {
                $key = if ($entry -is [System.Collections.DictionaryEntry]) { $entry.Key } else { $entry.Name }
                $value = if ($entry -is [System.Collections.DictionaryEntry]) { $entry.Value } else { $entry.Value }
                $rows += '<TR><TD COLSPAN="{0}" ALIGN="LEFT"><FONT FACE="{1}" COLOR="{2}" POINT-SIZE="{3}">{4}: {5}</FONT></TD></TR>' -f $columnCount, $escape.Invoke($FontName), $escape.Invoke($FontColor), $SubtitleFontSize, $escape.Invoke([string] $key), $escape.Invoke([string] $value)
            }
        }

        $html = '<TABLE PORT="{0}" STYLE="ROUNDED" BORDER="{1}" CELLBORDER="0" CELLSPACING="0" CELLPADDING="{2}" BGCOLOR="{3}" COLOR="{4}">{5}</TABLE>' -f $escape.Invoke($Port), $Border, $CellPadding, $escape.Invoke($BackgroundColor), $escape.Invoke($BorderColor), $rows
        Format-NodeObject -Name $Name -HtmlObject $html -GraphvizAttributes $GraphvizAttributes -AsHtml:(-not $NodeObject)
    }
}
