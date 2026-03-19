#    ** This example demonstrates the Add-HtmlTableCell cmdlet for dynamically building
#       Graphviz node detail tables from various structured input types. **

<#
    This example shows how Add-HtmlTableCell converts Hashtable, OrderedDictionary,
    PSCustomObject, and string array inputs into HTML <TR><TD> markup, which is then
    wrapped by Format-HtmlTable and assigned to a Graphviz node label.

    Add-HtmlTableCell is the low-level building block: it generates the row/cell markup
    that other higher-level functions (Add-HtmlTable, Add-NodeIcon) compose internally.
    Using it directly gives full control over the table structure.
#>

[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [array] $Format = @('png'),
    [bool] $DraftMode = $false
)

# Import-Module AsBuiltReport.Diagram -Force -Verbose:$false

$OutputFolderPath = Resolve-Path -Path $Path

$RootPath = $PSScriptRoot
[System.IO.FileInfo]$IconPath = Join-Path -Path $RootPath -ChildPath 'Icons'

$script:Images = @{
    'Main_Logo' = 'AsBuiltReport.png'
    'Server'    = 'Server.png'
    'Database'  = 'Database.png'
    'Switch'    = 'Switch.png'
    'Router'    = 'Router.png'
}

$MainGraphLabel = 'Add-HtmlTableCell Example'

$example18 = & {

    SubGraph Inventory -Attributes @{Label = 'Datacenter Inventory'; fontsize = 22; penwidth = 1.5; labelloc = 't'; style = 'dashed,rounded'; color = 'darkgray' } {

        <#
            --- Example A: PSCustomObject input ---
            Add-HtmlTableCell converts each property of a PSCustomObject into a
            "Name: Value" table row. The resulting cells are passed to Format-HtmlTable,
            which wraps them in the outer <TABLE> element required by Graphviz.
        #>

        $WebServerProps = [PSCustomObject][ordered]@{
            OS      = 'RHEL 10'
            Version = '10.1'
            CPU     = '8 vCPU'
            RAM     = '32 GB'
        }

        $WebCells = Add-HtmlTableCell -Rows $WebServerProps -FontSize 14 -IconDebug:$DraftMode
        $WebTable = Format-HtmlTable -TableRowContent $WebCells -TableBorder 1 -CellBorder 0 -CellSpacing 0 -CellPadding 5 -TableBorderColor '#4A90D9' -TableBackgroundColor '#EEF6FF'
        Node 'Web-Server-01' @{ label = $WebTable; shape = 'plain' }

        <#
            --- Example B: OrderedDictionary input ---
            An ordered dictionary preserves insertion order, which is important when
            the sequence of rows carries meaning (e.g., interface list, version history).
        #>

        $DBProps = [ordered]@{
            Engine  = 'PostgreSQL'
            Version = '16.2'
            Port    = '5432'
            Storage = '2 TB'
        }

        $DBCells = Add-HtmlTableCell -Rows $DBProps -FontSize 14 -FontColor '#1A1A1A' -IconDebug:$DraftMode
        $DBTable = Format-HtmlTable -TableRowContent $DBCells -TableBorder 1 -CellBorder 0 -CellSpacing 0 -CellPadding 5 -TableBorderColor '#27AE60' -TableBackgroundColor '#EAFAF1'
        Node 'DB-Server-01' @{ label = $DBTable; shape = 'plain' }

        <#
            --- Example C: string array input ---
            A string array produces one row per element. This is useful for lists such as
            VLANs, IP prefixes, or port descriptions where there is no key-value structure.
        #>

        $SwitchPorts = @(
            'Gi0/0  — 10.0.1.1/30'
            'Gi0/1  — 10.0.2.1/30'
            'Gi0/2  — 10.0.3.1/30'
            'Gi0/3  — unused'
        )

        $PortCells = Add-HtmlTableCell -Rows $SwitchPorts -Align 'Left' -FontSize 13 -FontName 'Courier New' -IconDebug:$DraftMode
        $PortTable = Format-HtmlTable -TableRowContent $PortCells -TableBorder 1 -CellBorder 0 -CellSpacing 0 -CellPadding 5 -TableBorderColor '#8E44AD' -TableBackgroundColor '#F5EEF8'
        Node 'Core-Switch-01' @{ label = $PortTable; shape = 'plain' }

        <#
            --- Example D: combining Add-HtmlTableCell with a header row ---
            Build a header cell manually using the same format, then concatenate with
            data cells before wrapping — demonstrating composability.
        #>

        $RouterProps = [PSCustomObject][ordered]@{
            Model   = 'Cisco ASR 1002-X'
            IOS     = '17.9.4'
            Uptime  = '42 days'
            BGP     = 'AS 65001'
        }

        $HeaderCell = '<TR><TD BGCOLOR="#2C3E50" ALIGN="Center" COLSPAN="1" CELLPADDING="6" BORDER="0"><FONT FACE="Segoe Ui" POINT-SIZE="15" COLOR="#FFFFFF"><B>Core Router</B></FONT></TD></TR>'
        $RouterCells = Add-HtmlTableCell -Rows $RouterProps -FontSize 14 -IconDebug:$DraftMode
        $RouterTable = Format-HtmlTable -TableRowContent ($HeaderCell + $RouterCells) -TableBorder 1 -CellBorder 0 -CellSpacing 0 -CellPadding 4 -TableBorderColor '#2C3E50' -TableBackgroundColor '#FDFEFE'
        Node 'Core-Router-01' @{ label = $RouterTable; shape = 'plain' }

        <#
            Connect nodes to show relationships.
        #>

        Edge -From 'Core-Switch-01' -To 'Web-Server-01' @{ label = 'Gi0/0'; fontsize = 12 }
        Edge -From 'Core-Switch-01' -To 'DB-Server-01'  @{ label = 'Gi0/1'; fontsize = 12 }
        Edge -From 'Core-Router-01' -To 'Core-Switch-01' @{ label = 'uplink'; fontsize = 12 }

        Rank 'Web-Server-01', 'DB-Server-01'
    }
}

New-AbrDiagram -InputObject $example18 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example18 -LogoName 'Main_Logo' -Direction top-to-bottom -IconPath $IconPath -ImagesObj $Images -DraftMode:$DraftMode
