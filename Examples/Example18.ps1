<#
    This example demonstrates Graphviz card nodes created with Add-NodeCard.
    Each card contains an optional icon, title, subtitle, and metadata rows, matching the
    visual structure of a ChartForgeX Card node while remaining compatible with PSGraph.
#>

[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [array] $Format = @('png')
)

# Import-Module AsBuiltReport.Diagram -Force -Verbose:$false

$OutputFolderPath = Resolve-Path -Path $Path
$IconPath = Join-Path -Path $PSScriptRoot -ChildPath 'Icons'
$ServerIcon = Join-Path -Path $IconPath -ChildPath 'Server.png'

$example18 = & {
    SubGraph Application -Attributes @{
        Label    = 'Three-Tier Application'
        fontsize = 20
        labelloc = 't'
        style    = 'dashed,rounded'
        color    = 'darkgray'
    } {
        Add-NodeCard -Name 'Web01' -Label 'Web-Server-01' -Subtitle 'Red Hat Linux 10' -IconPath $ServerIcon -AdditionalInfo ([ordered]@{
                IP   = '10.0.0.10'
                Role = 'Web'
            }) -BackgroundColor '#EFF6FF' -BorderColor '#2563EB' -NodeObject

        Add-NodeCard -Name 'App01' -Label 'App-Server-01' -Subtitle 'Windows Server 2022' -IconPath $ServerIcon -AdditionalInfo ([ordered]@{
                IP   = '10.0.0.20'
                Role = 'Application'
            }) -BackgroundColor '#F0FDF4' -BorderColor '#16A34A' -NodeObject

        Add-NodeCard -Name 'Db01' -Label 'Db-Server-01' -Subtitle 'Oracle Linux 9' -IconPath $ServerIcon -AdditionalInfo ([ordered]@{
                IP   = '10.0.0.30'
                Role = 'Database'
            }) -BackgroundColor '#FFF7ED' -BorderColor '#EA580C' -NodeObject

        Add-NodeEdge -From 'Web01' -To 'App01' -EdgeLabel 'HTTPS' -EdgeColor '#2563EB' -EdgeThickness 2 -EdgeLength 2
        Add-NodeEdge -From 'App01' -To 'Db01' -EdgeLabel 'SQL' -EdgeColor '#EA580C' -EdgeThickness 2 -EdgeLength 2
    }
}

New-AbrDiagram -InputObject $example18 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel 'Graphviz Card Nodes' -Filename Example18 -Direction top-to-bottom
