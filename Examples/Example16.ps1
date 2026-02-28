#    ** This example demonstrates how to use the Add-DiaHtmlTableCell cmdlet to dynamically build HTML table cells from a hashtable. (part of Diagrammer.Core) **

<#
    This example shows how Add-DiaHtmlTableCell converts a hashtable or PSCustomObject into
    Graphviz-compatible HTML table cell rows. The resulting cells are combined with Format-HtmlTable
    to produce a node label that displays key-value data in a structured table layout.
#>

[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [array] $Format = @('png'),
    [bool] $DraftMode = $false
)

<#
    Starting with PowerShell v3, modules are auto-imported when needed.
    It is included here for clarity.
#>

# Import-Module Diagrammer.Core -Force -Verbose:$false

<#
    The diagram output is a file, so we need to specify the output folder path. In this example, $OutputFolderPath is used.
#>

$OutputFolderPath = Resolve-Path -Path $Path

<#
    If the diagram uses custom icons, specify the path to the icons directory. This is a Graphviz requirement.
#>

$RootPath = $PSScriptRoot
[System.IO.FileInfo]$IconPath = Join-Path -Path $RootPath -ChildPath 'Icons'

<#
    The $Images variable is a hashtable containing the names of image files used in the diagram.
    The image files must be located in the directory specified by $IconPath.
    ** Image sizes should be around 100x100, 150x150 pixels for optimal display. **
#>

$script:Images = @{
    'Main_Logo' = 'Diagrammer.png'
    'Server' = 'Server.png'
}

<#
    The $MainGraphLabel variable sets the main title of the diagram.
#>

$MainGraphLabel = 'Server Information Diagram'

<#
    This section creates PSCustomObjects to hold server information.
    These objects are used with Add-DiaHtmlTableCell to build the node table cells.
#>

$WebServerInfo = [PSCustomObject][ordered]@{
    'OS'      = 'Ubuntu Linux 22.04'
    'CPU'     = '4 vCPUs'
    'Memory'  = '8 GB'
    'IP'      = '10.0.1.100'
}

$DbServerInfo = [PSCustomObject][ordered]@{
    'OS'      = 'Oracle Linux 8'
    'CPU'     = '8 vCPUs'
    'Memory'  = '32 GB'
    'IP'      = '10.0.1.200'
}

$example16 = & {

    <#
        Add-DiaHtmlTableCell converts a hashtable or PSCustomObject into a series of
        HTML TR/TD elements, with each key-value pair rendered as a table row.

        Format-HtmlTable wraps the cells in an HTML TABLE element with the specified style.

        The resulting HTML is used as the Graphviz node label via Add-DiaNodeIcon.

        ** The $Images object and IconType "Server" must be defined earlier in the script **
    #>

    Add-DiaNodeIcon -Name 'Web-Server-01' -AditionalInfo $WebServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Left' -FontSize 14 -DraftMode:$DraftMode -NodeObject

    Add-DiaNodeIcon -Name 'DB-Server-01' -AditionalInfo $DbServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Left' -FontSize 14 -DraftMode:$DraftMode -NodeObject

    <#
        This section creates a connection between the nodes.
        The Edge statement creates a connection between Web-Server-01 and DB-Server-01.
        (Edge is a reserved word in the PSGraph module)
        https://psgraph.readthedocs.io/en/latest/Command-Edge/
    #>

    Edge -From 'Web-Server-01' -To 'DB-Server-01' @{label = 'SQL'; color = 'black'; fontsize = 14; fontcolor = 'black'; minlen = 3 }
}

<#
    This command generates the diagram using the New-Diagrammer cmdlet (part of Diagrammer.Core).
#>

New-Diagrammer -InputObject $example16 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example16 -LogoName 'Main_Logo' -Direction top-to-bottom -IconPath $IconPath -ImagesObj $Images -DraftMode:$DraftMode
