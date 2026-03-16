#    ** This time, we'll demonstrate the use of the Rank cmdlet (Part of PSGraph module). **

<#
    This example demonstrates how to create a 3-tier web application diagram using the AsBuiltReport.Diagram.
#>

[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [array] $Format = @('png'),
    [bool] $DraftMode = $false
)

<#
    Starting with PowerShell v3, modules do not need to be explicitly imported.
    It is included here for clarity.
#>

# Import-Module AsBuiltReport.Diagram -Force -Verbose:$false

<#
    The diagram output is a file, so we need to specify the output folder path. In this example, $OutputFolderPath is used.
#>

$OutputFolderPath = Resolve-Path $Path

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
    'Main_Logo' = 'AsBuiltReport.png'
    'Server' = 'Server.png'
}

<#
    The $MainGraphLabel variable sets the main title of the diagram.
#>

$MainGraphLabel = 'Web Application Diagram'

<#
    This section creates custom objects to hold server information, which are used to set node labels in the diagram.
#>

$WebServerInfo = [PSCustomObject][ordered]@{
    'OS' = 'Redhat Linux'
    'Version' = '10'
    'Build' = '10.1'
    'Edition' = 'Enterprise'
}

$AppServerInfo = [PSCustomObject][ordered]@{
    'OS' = 'Windows Server'
    'Version' = '2019'
    'Build' = '17763.3163'
    'Edition' = 'Datacenter'
}

$DBServerInfo = [PSCustomObject][ordered]@{
    'OS' = 'Oracle Server'
    'Version' = '8'
    'Build' = '8.2'
    'Edition' = 'Enterprise'
}

$example7 = & {
    <#
        A SubGraph allows you to group objects in a container, creating a graph within a graph.
        SubGraph, Node, and Edge have attributes for setting background color, label, border color, style, etc.
        (SubGraph is a reserved word in the PSGraph module)
        https://psgraph.readthedocs.io/en/latest/Command-SubGraph/
    #>

    SubGraph 3tier -Attributes @{Label = '3 Tier Concept'; fontsize = 18; penwidth = 1.5; labelloc = 't'; style = 'dashed,rounded'; color = 'darkgray' } {

        <#
            This time, we enhance the diagram by adding images to the Node objects and embedding information to describe server properties.
            Graphviz supports HTML tables to extend object labels, allowing images, text, and tables within Node, Edge, and Subgraph attribute script blocks.
            Add-NodeIcon extends PSGraph to improve the appearance of the generated diagram (Add-NodeIcon is part of AsBuiltReport.Diagram).
            ** The $Images object and IconType "Server" must be defined earlier in the script **

            -AdditionalInfo parameter accepts a custom object with properties to display in the node label.
            -Align parameter sets the alignment of the icon and text (Left, Right, Center).
            -ImagesObj parameter passes the hashtable of images defined earlier in the script.
            -FontSize 18 sets the font size for the node label text.
            -NodeObject switch returns a Node object for use in the PSGraph context.
            -DraftMode $true enables DraftMode, which adds a border around the node to help with positioning and layout adjustments.
        #>

        Add-NodeIcon -Name 'Web-Server-01' -AditionalInfo $WebServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Center' -FontSize 18 -DraftMode:$DraftMode -NodeObject
        Add-NodeIcon -Name 'App-Server-01' -AditionalInfo $AppServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Center' -FontSize 18 -DraftMode:$DraftMode -NodeObject
        Add-NodeIcon -Name 'Db-Server-01' -AditionalInfo $DBServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Center' -FontSize 18 -DraftMode:$DraftMode -NodeObject

        <#
            This section creates connections between the nodes in a hierarchical layout.
            The Add-NodeEdge cmdlet creates connections between the nodes. (Part of AsBuiltReport.Diagram module)
            https://github.com/AsBuiltReport/AsBuiltReport.Diagram
        #>

        Add-NodeEdge -From 'Web-Server-01' -To 'App-Server-01' -EdgeLabel 'gRPC' -EdgeColor 'black' -EdgeLabelFontSize 14 -EdgeLabelFontColor 'black' -EdgeLength 3 -EdgeThickness 3 -EdgeStyle 'dashed'
        Add-NodeEdge -From 'App-Server-01' -To 'Db-Server-01' -EdgeLabel 'SQL' -EdgeColor 'black' -EdgeLabelFontSize 14 -EdgeLabelFontColor 'black' -EdgeLength 3 -EdgeThickness 3 -EdgeStyle 'dashed'

        <#
            The Rank cmdlet is used to place nodes at the same hierarchical level.
            In this example, App-Server-01 and Db-Server-01 are aligned horizontally.
            https://psgraph.readthedocs.io/en/stable/Command-Rank-Advanced/
        #>
        Rank -Nodes 'App-Server-01', 'Db-Server-01'
    }
}

<#
    This command generates the diagram using the New-AbrDiagram cmdlet (part of AsBuiltReport.Diagram).
#>

New-AbrDiagram -InputObject $example7 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example7 -LogoName 'Main_Logo' -Direction top-to-bottom -IconPath $IconPath -ImagesObj $Images -DraftMode:$DraftMode

