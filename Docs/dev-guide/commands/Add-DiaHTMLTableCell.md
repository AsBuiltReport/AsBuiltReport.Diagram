---
document type: cmdlet
external help file: Diagrammer.Core-Help.xml
HelpUri: ''
Locale: en-US
Module Name: Diagrammer.Core
ms.date: 02/28/2026
PlatyPS schema version: 2024-05-01
title: Add-DiaHTMLTableCell
---

# Add-DiaHTMLTableCell

## SYNOPSIS

Dynamically builds HTML table cell rows (TR/TD) from an input hashtable.

## SYNTAX

### __AllParameteSets

```
Add-DiaHtmlTableCell [-Rows] <Object> [[-Align] <String>] [[-FontSize] <Int32>]
 [[-CellBackgroundColor] <String>] [[-IconDebug] <Boolean>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,

- None

## DESCRIPTION

Converts a hashtable, ordered dictionary, PSCustomObject, or array of such objects into a series of HTML table row/cell (TR/TD) elements suitable for embedding in Graphviz node labels. Use Format-HtmlTable to wrap the output in an HTML TABLE element.

## EXAMPLES

### EXAMPLE 1

```powershell
$ServerInfo = [ordered]@{
    'OS'     = 'Windows Server 2019'
    'CPU'    = '4 Cores'
    'Memory' = '16 GB'
}
Add-DiaHtmlTableCell -Rows $ServerInfo
```

!!! example
    === "Example 1"

        ```graphviz dot AddDiaHTMLTableCell.png
            digraph g {
                node [shape=plain];
                a [label=<<TABLE PORT="EdgeDot" STYLE="SOLID" BORDER="0" CELLBORDER="0" CELLSPACING="5" CELLPADDING="5" BGCOLOR="#ffffff" COLOR="#000000"><TR><TD PORT="OS" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">OS: Windows Server 2019</FONT></TD></TR><TR><TD PORT="CPU" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">CPU: 4 Cores</FONT></TD></TR><TR><TD PORT="Memory" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">Memory: 16 GB</FONT></TD></TR></TABLE>>];
            }
        ```

```powershell
$ServerInfo = [PSCustomObject][ordered]@{
    'OS'     = 'Windows Server 2019'
    'CPU'    = '4 Cores'
    'Memory' = '16 GB'
}
Add-DiaHtmlTableCell -Rows $ServerInfo -Align 'Left' -CellBackgroundColor '#E0E0E0'
```

!!! example
    === "Example 2"

        ```graphviz dot AddDiaHTMLTableCell2.png
            digraph g {
                node [shape=plain];
                a [label=<<TABLE PORT="EdgeDot" STYLE="SOLID" BORDER="0" CELLBORDER="0" CELLSPACING="5" CELLPADDING="5" BGCOLOR="#ffffff" COLOR="#000000"><TR><TD PORT="OS" BGCOLOR="#E0E0E0" ALIGN="Left" colspan="1"><FONT POINT-SIZE="14">OS: Windows Server 2019</FONT></TD></TR><TR><TD PORT="CPU" BGCOLOR="#E0E0E0" ALIGN="Left" colspan="1"><FONT POINT-SIZE="14">CPU: 4 Cores</FONT></TD></TR><TR><TD PORT="Memory" BGCOLOR="#E0E0E0" ALIGN="Left" colspan="1"><FONT POINT-SIZE="14">Memory: 16 GB</FONT></TD></TR></TABLE>>];
            }
        ```
    === "Example 2 - DraftMode"

        ```graphviz dot AddDiaHTMLTableCell2_draftmode.png
            digraph g {
                node [shape=plain];
                a [label=<<TABLE PORT="EdgeDot" STYLE="SOLID" BORDER="1" CELLBORDER="0" CELLSPACING="5" CELLPADDING="5" BGCOLOR="white" COLOR="red"><TR><TD PORT="OS" BGCOLOR="#FFCCCC" ALIGN="Left" colspan="1"><FONT POINT-SIZE="14">OS: Windows Server 2019</FONT></TD></TR><TR><TD PORT="CPU" BGCOLOR="#FFCCCC" ALIGN="Left" colspan="1"><FONT POINT-SIZE="14">CPU: 4 Cores</FONT></TD></TR><TR><TD PORT="Memory" BGCOLOR="#FFCCCC" ALIGN="Left" colspan="1"><FONT POINT-SIZE="14">Memory: 16 GB</FONT></TD></TR></TABLE>>];
            }
        ```

## PARAMETERS

### -Rows

A hashtable, ordered dictionary, PSCustomObject, or array of such objects to convert to HTML table cells. Each key-value pair is rendered as a table row in the format "Key: Value".

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Align

Specifies the alignment of the content inside the table cell. Acceptable values are 'Center', 'Right', or 'Left'. Default is 'Center'.

```yaml
Type: System.String
DefaultValue: Center
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues:
- Center
- Right
- Left
HelpMessage: ''
```

### -FontSize

Specifies the font size for the text inside the cells. Default is 14.

```yaml
Type: System.Int32
DefaultValue: 14
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CellBackgroundColor

Specifies the background color of each cell. Default is '#FFFFFF'.

```yaml
Type: System.String
DefaultValue: '#FFFFFF'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IconDebug

Enables debug mode (highlights cells with a red background for troubleshooting).

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases:
- DraftMode
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

A string containing TR/TD HTML elements suitable for embedding in a Graphviz HTML TABLE label.

## NOTES

```
Version:        0.2.40
Author:         Jonathan Colon
Bluesky:        @jcolonfpr.bsky.social
Github:         rebelinux
```


## RELATED LINKS

[Diagrammer.Core](https://github.com/rebelinux/Diagrammer.Core)
