---
comments: true
hide:
  - toc
---

This example demonstrates how to use the **`Add-DiaHtmlTableCell`** (part of Diagrammer.Core) cmdlet to dynamically build HTML table cells from a hashtable or PSCustomObject.

The `Add-DiaHtmlTableCell` cmdlet converts a hashtable, ordered dictionary, PSCustomObject, or array of such objects into a series of HTML table row/cell (TR/TD) elements. Each key-value pair is rendered as a row in the format "Key: Value", making it easy to display structured data—such as server properties—as a node label in a Graphviz diagram.

```powershell title="PowerShell: Example16.ps1 - param block"
[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [array] $Format = @('png'),
    [bool] $DraftMode = $false
)
```

Starting with PowerShell v3, modules are auto-imported when needed. Importing the module here ensures clarity and avoids ambiguity.

```powershell
Import-Module Diagrammer.Core -Force -Verbose:$false
```

Since the diagram output is a file, specify the output folder path using $OutputFolderPath.

```powershell
$OutputFolderPath = Resolve-Path $Path
```

The $MainGraphLabel variable sets the main title of the diagram.

```powershell
$MainGraphLabel = 'Server Information Diagram'
```

If the diagram uses custom icons, specify the path to the icons directory. This is a Graphviz requirement.

```powershell
$RootPath = $PSScriptRoot
[System.IO.FileInfo]$IconPath = Join-Path -Path $RootPath -ChildPath 'Icons'
```

The $Images variable is a hashtable containing the names of image files used in the diagram. The image files must be located in the directory specified by $IconPath.

** Image sizes should be around 100x100, 150x150 pixels for optimal display. **

```powershell
$script:Images = @{
    'Main_Logo' = 'Diagrammer.png'
    'Server'    = 'Server.png'
}
```

Create PSCustomObjects to hold server information. `Add-DiaHtmlTableCell` accepts hashtables, ordered dictionaries, and PSCustomObjects.

```powershell
$WebServerInfo = [PSCustomObject][ordered]@{
    'OS'     = 'Ubuntu Linux 22.04'
    'CPU'    = '4 vCPUs'
    'Memory' = '8 GB'
    'IP'     = '10.0.1.100'
}

$DbServerInfo = [PSCustomObject][ordered]@{
    'OS'     = 'Oracle Linux 8'
    'CPU'    = '8 vCPUs'
    'Memory' = '32 GB'
    'IP'     = '10.0.1.200'
}
```

Use `Add-DiaNodeIcon` with the `AditionalInfo` parameter to embed the PSCustomObject data as table cells in the node label. Internally, this uses `Add-DiaHtmlTableCell` to convert the hashtable into TR/TD HTML rows.

```powershell
$example16 = & {
    Add-DiaNodeIcon -Name 'Web-Server-01' -AditionalInfo $WebServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Left' -FontSize 14 -DraftMode:$DraftMode -NodeObject

    Add-DiaNodeIcon -Name 'DB-Server-01' -AditionalInfo $DbServerInfo -ImagesObj $Images -IconType 'Server' -Align 'Left' -FontSize 14 -DraftMode:$DraftMode -NodeObject

    Edge -From 'Web-Server-01' -To 'DB-Server-01' @{label = 'SQL'; color = 'black'; fontsize = 14; fontcolor = 'black'; minlen = 3 }
}
```

This command generates the diagram using the New-Diagrammer cmdlet (part of Diagrammer.Core).

```powershell
New-Diagrammer -InputObject $example16 -OutputFolderPath $OutputFolderPath -Format $Format -MainDiagramLabel $MainGraphLabel -Filename Example16 -LogoName 'Main_Logo' -Direction top-to-bottom -IconPath $IconPath -ImagesObj $Images -DraftMode:$DraftMode
```
