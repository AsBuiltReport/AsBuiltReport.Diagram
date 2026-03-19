BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Format-HtmlFontProperty.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-HtmlTableCell.ps1')
}

Describe 'Add-HtmlTableCell' {

    Context 'string array input' {
        It 'returns one TR per string with default formatting' {
            $result = Add-HtmlTableCell -Rows @('alpha', 'beta')
            $result | Should -Match '<TR><TD PORT="EdgeDot".*>.*alpha.*</TD></TR>'
            $result | Should -Match '<TR><TD PORT="EdgeDot".*>.*beta.*</TD></TR>'
        }

        It 'uses the Port parameter for the TD PORT attribute' {
            $result = Add-HtmlTableCell -Rows @('item') -Port 'p1'
            $result | Should -Match 'PORT="p1"'
        }

        It 'applies custom Align value' {
            $result = Add-HtmlTableCell -Rows @('item') -Align 'Left'
            $result | Should -Match 'ALIGN="Left"'
        }

        It 'applies custom ColSpan value' {
            $result = Add-HtmlTableCell -Rows @('item') -ColSpan 3
            $result | Should -Match 'COLSPAN="3"'
        }

        It 'uses CellBackgroundColor in normal mode' {
            $result = Add-HtmlTableCell -Rows @('item') -CellBackgroundColor '#AABBCC'
            $result | Should -Match 'BGCOLOR="#AABBCC"'
        }

        It 'overrides background with red in IconDebug mode' {
            $result = Add-HtmlTableCell -Rows @('item') -CellBackgroundColor '#AABBCC' -IconDebug $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
            $result | Should -Not -Match 'BGCOLOR="#AABBCC"'
        }

        It 'DraftMode alias behaves the same as IconDebug' {
            $result = Add-HtmlTableCell -Rows @('item') -DraftMode $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
        }

        It 'contains formatted font markup inside the cell' {
            $result = Add-HtmlTableCell -Rows @('hello') -FontSize 18 -FontColor '#FF0000' -FontBold
            $result | Should -Match 'POINT-SIZE="18"'
            $result | Should -Match 'COLOR="#FF0000"'
            $result | Should -Match '<B>hello</B>'
        }

        It 'applies CellBorder to the BORDER attribute' {
            $result = Add-HtmlTableCell -Rows @('x') -CellBorder 2
            $result | Should -Match 'BORDER="2"'
        }

        It 'applies CellPadding to the CELLPADDING attribute' {
            $result = Add-HtmlTableCell -Rows @('x') -CellPadding 8
            $result | Should -Match 'CELLPADDING="8"'
        }

        It 'produces the exact expected string for a single item' {
            $expected = '<TR><TD PORT="EdgeDot" BGCOLOR="#FFFFFF" ALIGN="Center" COLSPAN="1" CELLPADDING="5" BORDER="0"><FONT FACE="Segoe Ui" POINT-SIZE="14" COLOR="#000000">hello</FONT></TD></TR>'
            $result = Add-HtmlTableCell -Rows @('hello')
            $result | Should -BeExactly $expected
        }
    }

    Context 'Hashtable input' {
        It 'returns one TR per key-value pair' {
            $result = Add-HtmlTableCell -Rows @{ OS = 'Windows'; RAM = '32GB' }
            $result | Should -Match 'OS: Windows'
            $result | Should -Match 'RAM: 32GB'
        }

        It 'uses the hashtable key as the PORT attribute' {
            $result = Add-HtmlTableCell -Rows @{ MyKey = 'value' }
            $result | Should -Match 'PORT="MyKey"'
        }
    }

    Context 'OrderedDictionary input' {
        It 'preserves entry order and produces key: value rows' {
            $od = [ordered]@{ CPU = '8 vCPU'; RAM = '32 GB'; Disk = '500 GB' }
            $result = Add-HtmlTableCell -Rows $od
            $result | Should -Match 'CPU: 8 vCPU'
            $result | Should -Match 'RAM: 32 GB'
            $result | Should -Match 'Disk: 500 GB'
            # Verify order: CPU appears before RAM, RAM before Disk
            $cpuIdx  = $result.IndexOf('CPU:')
            $ramIdx  = $result.IndexOf('RAM:')
            $diskIdx = $result.IndexOf('Disk:')
            $cpuIdx  | Should -BeLessThan $ramIdx
            $ramIdx  | Should -BeLessThan $diskIdx
        }

        It 'uses the dictionary key as the PORT attribute' {
            $od = [ordered]@{ Version = '2019' }
            $result = Add-HtmlTableCell -Rows $od
            $result | Should -Match 'PORT="Version"'
        }

        It 'produces the exact expected string for a single ordered entry' {
            $od = [ordered]@{ OS = 'Linux' }
            $expected = '<TR><TD PORT="OS" BGCOLOR="#FFFFFF" ALIGN="Center" COLSPAN="1" CELLPADDING="5" BORDER="0"><FONT FACE="Segoe Ui" POINT-SIZE="14" COLOR="#000000">OS: Linux</FONT></TD></TR>'
            $result = Add-HtmlTableCell -Rows $od
            $result | Should -BeExactly $expected
        }
    }

    Context 'PSCustomObject input' {
        It 'returns one TR per property' {
            $obj = [PSCustomObject]@{ Name = 'Server01'; Role = 'Web' }
            $result = Add-HtmlTableCell -Rows $obj
            $result | Should -Match 'Name: Server01'
            $result | Should -Match 'Role: Web'
        }

        It 'uses the property name as the PORT attribute' {
            $obj = [PSCustomObject]@{ Version = '10.1' }
            $result = Add-HtmlTableCell -Rows $obj
            $result | Should -Match 'PORT="Version"'
        }

        It 'handles ordered PSCustomObject' {
            $obj = [PSCustomObject][ordered]@{ A = '1'; B = '2'; C = '3' }
            $result = Add-HtmlTableCell -Rows $obj
            $result | Should -Match 'A: 1'
            $result | Should -Match 'B: 2'
            $result | Should -Match 'C: 3'
        }
    }

    Context 'font formatting options' {
        It 'applies FontItalic' {
            $result = Add-HtmlTableCell -Rows @('text') -FontItalic
            $result | Should -Match '<I>text</I>'
        }

        It 'applies FontUnderline' {
            $result = Add-HtmlTableCell -Rows @('text') -FontUnderline
            $result | Should -Match '<U>text</U>'
        }

        It 'applies FontStrikeThrough' {
            $result = Add-HtmlTableCell -Rows @('text') -FontStrikeThrough
            $result | Should -Match '<S>text</S>'
        }

        It 'applies custom FontName' {
            $result = Add-HtmlTableCell -Rows @('text') -FontName 'Arial'
            $result | Should -Match 'FACE="Arial"'
        }

        It 'InputObject alias works identically to Rows' {
            $r1 = Add-HtmlTableCell -Rows @('x')
            $r2 = Add-HtmlTableCell -InputObject @('x')
            $r1 | Should -BeExactly $r2
        }
    }

    Context 'composability with Format-HtmlTable' {
        BeforeAll {
            . (Join-Path -Path $PrivateFolder -ChildPath 'Format-HtmlTable.ps1')
        }

        It 'output can be consumed directly by Format-HtmlTable' {
            $cells = Add-HtmlTableCell -Rows @('row1', 'row2')
            { Format-HtmlTable -TableRowContent $cells } | Should -Not -Throw
        }

        It 'resulting table contains the cell content' {
            $cells = Add-HtmlTableCell -Rows @('myvalue')
            $table = Format-HtmlTable -TableRowContent $cells
            $table | Should -Match 'myvalue'
            $table | Should -Match '^<TABLE\b.*>.*</TABLE>$'
        }
    }
}
