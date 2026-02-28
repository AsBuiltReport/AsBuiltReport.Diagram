function Add-DiaHtmlTableCell {
    <#
    .SYNOPSIS
        Dynamically builds HTML table cell rows (TR/TD) from an input hashtable.
    .DESCRIPTION
        Converts a hashtable, ordered dictionary, PSCustomObject, or array of such objects
        into a series of HTML table row/cell (TR/TD) elements suitable for embedding in
        Graphviz node labels. Use Format-HtmlTable to wrap the output in an HTML TABLE element.
    .EXAMPLE
        $ServerInfo = [ordered]@{
            'OS'     = 'Windows Server 2019'
            'CPU'    = '4 Cores'
            'Memory' = '16 GB'
        }
        Add-DiaHtmlTableCell -Rows $ServerInfo
    .NOTES
        Version:        0.2.40
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux
    .PARAMETER Rows
        A hashtable, ordered dictionary, PSCustomObject, or array of such objects to convert to HTML table cells.
        Each key-value pair is rendered as a table row in the format "Key: Value".
    .PARAMETER Align
        Specifies the alignment of the content inside the table cell. Acceptable values are 'Center', 'Right', or 'Left'. Default is 'Center'.
    .PARAMETER FontSize
        Specifies the font size for the text inside the cells. Default is 14.
    .PARAMETER CellBackgroundColor
        Specifies the background color of each cell. Default is '#FFFFFF'.
    .PARAMETER IconDebug
        Enables debug mode (highlights cells with a red background for troubleshooting).
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(
            Mandatory,
            HelpMessage = 'A hashtable, ordered dictionary, PSCustomObject, or array to convert to HTML table cells.'
        )]
        $Rows,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Specifies the alignment of the content inside the table cell.'
        )]
        [ValidateSet('Center', 'Right', 'Left')]
        [string] $Align = 'Center',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Specifies the font size for the text inside the cells.'
        )]
        [int] $FontSize = 14,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Specifies the background color of each cell.'
        )]
        [string] $CellBackgroundColor = '#FFFFFF',

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Enables debug mode (highlights cells with a red background).'
        )]
        [Alias('DraftMode')]
        [bool] $IconDebug = $false
    )

    $TRContent = ''
    $BgColor = if ($IconDebug) { '#FFCCCC' } else { $CellBackgroundColor }
    $cellTemplate = '<TR><TD PORT="{0}" BGCOLOR="{1}" ALIGN="{2}" colspan="1"><FONT POINT-SIZE="{3}">{4}: {5}</FONT></TD></TR>'

    switch ($Rows.GetType().Name) {
        'Hashtable' {
            foreach ($entry in $Rows.GetEnumerator()) {
                $TRContent += $cellTemplate -f $entry.Key, $BgColor, $Align, $FontSize, $entry.Key, $entry.Value
            }
        }
        'OrderedDictionary' {
            foreach ($entry in $Rows.GetEnumerator()) {
                $TRContent += $cellTemplate -f $entry.Key, $BgColor, $Align, $FontSize, $entry.Key, $entry.Value
            }
        }
        'PSCustomObject' {
            foreach ($prop in $Rows.PSObject.Properties) {
                $TRContent += $cellTemplate -f $prop.Name, $BgColor, $Align, $FontSize, $prop.Name, $prop.Value
            }
        }
        'Object[]' {
            foreach ($r in $Rows) {
                foreach ($prop in $r.PSObject.Properties) {
                    $TRContent += $cellTemplate -f $prop.Name, $BgColor, $Align, $FontSize, $prop.Name, $prop.Value
                }
            }
        }
    }

    return $TRContent
}
