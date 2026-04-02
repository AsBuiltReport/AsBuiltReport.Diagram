BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Format-HtmlFontProperty.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Format-HtmlCell.ps1')
}

Describe 'Format-HtmlCell' {

    Context 'string array input' {
        It 'returns one TR per string with default formatting' {
            $result = Format-HtmlCell -Rows @('alpha', 'beta')
            $result | Should -Match '<TR><TD PORT="EdgeDot".*>.*alpha.*</TD></TR>'
            $result | Should -Match '<TR><TD PORT="EdgeDot".*>.*beta.*</TD></TR>'
        }

        It 'uses the Port parameter for the TD PORT attribute' {
            $result = Format-HtmlCell -Rows @('item') -Port 'p1'
            $result | Should -Match 'PORT="p1"'
        }

        It 'applies custom Align value' {
            $result = Format-HtmlCell -Rows @('item') -Align 'Left'
            $result | Should -Match 'ALIGN="Left"'
        }

        It 'applies custom ColSpan value' {
            $result = Format-HtmlCell -Rows @('item') -ColSpan 3
            $result | Should -Match 'COLSPAN="3"'
        }

        It 'uses CellBackgroundColor in normal mode' {
            $result = Format-HtmlCell -Rows @('item') -CellBackgroundColor '#AABBCC'
            $result | Should -Match 'BGCOLOR="#AABBCC"'
        }

        It 'overrides background with red in IconDebug mode' {
            $result = Format-HtmlCell -Rows @('item') -CellBackgroundColor '#AABBCC' -IconDebug $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
            $result | Should -Not -Match 'BGCOLOR="#AABBCC"'
        }

        It 'DraftMode alias behaves the same as IconDebug' {
            $result = Format-HtmlCell -Rows @('item') -DraftMode $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
        }

        It 'contains formatted font markup inside the cell' {
            $result = Format-HtmlCell -Rows @('hello') -FontSize 18 -FontColor '#FF0000' -FontBold
            $result | Should -Match 'POINT-SIZE="18"'
            $result | Should -Match 'COLOR="#FF0000"'
            $result | Should -Match '<B>hello</B>'
        }

        It 'applies CellBorder to the BORDER attribute' {
            $result = Format-HtmlCell -Rows @('x') -CellBorder 2
            $result | Should -Match 'BORDER="2"'
        }

        It 'applies CellPadding to the CELLPADDING attribute' {
            $result = Format-HtmlCell -Rows @('x') -CellPadding 8
            $result | Should -Match 'CELLPADDING="8"'
        }

        It 'produces the exact expected string for a single item' {
            $expected = '<TR><TD PORT="EdgeDot" BGCOLOR="#FFFFFF" ALIGN="Center" COLSPAN="1" CELLPADDING="5" BORDER="0"><FONT FACE="Segoe Ui" POINT-SIZE="14" COLOR="#000000">hello</FONT></TD></TR>'
            $result = Format-HtmlCell -Rows @('hello')
            $result | Should -BeExactly $expected
        }
    }

    Context 'Hashtable input' {
        It 'returns one TR per key-value pair' {
            $result = Format-HtmlCell -Rows @{ OS = 'Windows'; RAM = '32GB' }
            $result | Should -Match 'OS: Windows'
            $result | Should -Match 'RAM: 32GB'
        }

        It 'uses the hashtable key as the PORT attribute' {
            $result = Format-HtmlCell -Rows @{ MyKey = 'value' }
            $result | Should -Match 'PORT="MyKey"'
        }
    }

    Context 'OrderedDictionary input' {
        It 'preserves entry order and produces key: value rows' {
            $od = [ordered]@{ CPU = '8 vCPU'; RAM = '32 GB'; Disk = '500 GB' }
            $result = Format-HtmlCell -Rows $od
            $result | Should -Match 'CPU: 8 vCPU'
            $result | Should -Match 'RAM: 32 GB'
            $result | Should -Match 'Disk: 500 GB'
            # Verify order: CPU appears before RAM, RAM before Disk
            $cpuIdx = $result.IndexOf('CPU:')
            $ramIdx = $result.IndexOf('RAM:')
            $diskIdx = $result.IndexOf('Disk:')
            $cpuIdx | Should -BeLessThan $ramIdx
            $ramIdx | Should -BeLessThan $diskIdx
        }

        It 'uses the dictionary key as the PORT attribute' {
            $od = [ordered]@{ Version = '2019' }
            $result = Format-HtmlCell -Rows $od
            $result | Should -Match 'PORT="Version"'
        }

        It 'produces the exact expected string for a single ordered entry' {
            $od = [ordered]@{ OS = 'Linux' }
            $expected = '<TR><TD PORT="OS" BGCOLOR="#FFFFFF" ALIGN="Center" COLSPAN="1" CELLPADDING="5" BORDER="0"><FONT FACE="Segoe Ui" POINT-SIZE="14" COLOR="#000000">OS: Linux</FONT></TD></TR>'
            $result = Format-HtmlCell -Rows $od
            $result | Should -BeExactly $expected
        }
    }

    Context 'PSCustomObject input' {
        It 'returns one TR per property' {
            $obj = [PSCustomObject]@{ Name = 'Server01'; Role = 'Web' }
            $result = Format-HtmlCell -Rows $obj
            $result | Should -Match 'Name: Server01'
            $result | Should -Match 'Role: Web'
        }

        It 'uses the property name as the PORT attribute' {
            $obj = [PSCustomObject]@{ Version = '10.1' }
            $result = Format-HtmlCell -Rows $obj
            $result | Should -Match 'PORT="Version"'
        }

        It 'handles ordered PSCustomObject' {
            $obj = [PSCustomObject][ordered]@{ A = '1'; B = '2'; C = '3' }
            $result = Format-HtmlCell -Rows $obj
            $result | Should -Match 'A: 1'
            $result | Should -Match 'B: 2'
            $result | Should -Match 'C: 3'
        }
    }

    Context 'font formatting options' {
        It 'applies FontItalic' {
            $result = Format-HtmlCell -Rows @('text') -FontItalic
            $result | Should -Match '<I>text</I>'
        }

        It 'applies FontUnderline' {
            $result = Format-HtmlCell -Rows @('text') -FontUnderline
            $result | Should -Match '<U>text</U>'
        }

        It 'applies FontStrikeThrough' {
            $result = Format-HtmlCell -Rows @('text') -FontStrikeThrough
            $result | Should -Match '<S>text</S>'
        }

        It 'applies custom FontName' {
            $result = Format-HtmlCell -Rows @('text') -FontName 'Arial'
            $result | Should -Match 'FACE="Arial"'
        }

        It 'InputObject alias works identically to Rows' {
            $r1 = Format-HtmlCell -Rows @('x')
            $r2 = Format-HtmlCell -InputObject @('x')
            $r1 | Should -BeExactly $r2
        }
    }

    Context 'image cell (Image parameter set)' {
        It 'produces a TD with STYLE, ALIGN, colspan and an img tag' {
            $result = Format-HtmlCell -ImageSrc '/icons/server.png' -CellStyle SOLID
            $result | Should -BeExactly '<TR><TD STYLE="SOLID" ALIGN="Center" colspan="1"><img src="/icons/server.png"/></TD></TR>'
        }

        It 'honours a custom Align value' {
            $result = Format-HtmlCell -ImageSrc '/icons/vm.png' -CellStyle SOLID -Align Left
            $result | Should -Match 'ALIGN="Left"'
        }

        It 'honours a custom ColSpan value' {
            $result = Format-HtmlCell -ImageSrc '/icons/vm.png' -CellStyle SOLID -ColSpan 2
            $result | Should -Match 'colspan="2"'
        }

        It 'honours a custom CellStyle value' {
            $result = Format-HtmlCell -ImageSrc '/icons/vm.png' -CellStyle ROUNDED
            $result | Should -Match 'STYLE="ROUNDED"'
        }

        It 'adds fixedsize, width and height attributes when -FixedSize is set' {
            $result = Format-HtmlCell -ImageSrc '/icons/server.png' -CellStyle SOLID -FixedSize -Width 64 -Height 48
            $result | Should -BeExactly '<TR><TD STYLE="SOLID" ALIGN="Center" fixedsize="true" width="64" height="48" colspan="1"><img src="/icons/server.png"/></TD></TR>'
        }

        It 'does not include fixedsize attributes when -FixedSize is absent' {
            $result = Format-HtmlCell -ImageSrc '/icons/server.png' -CellStyle SOLID
            $result | Should -Not -Match 'fixedsize'
            $result | Should -Not -Match '\bwidth='
            $result | Should -Not -Match '\bheight='
        }

        It 'renders the image src as plain text in IconDebug mode' {
            $result = Format-HtmlCell -ImageSrc '/icons/debug.png' -CellStyle SOLID -IconDebug $true
            $result | Should -Match '/icons/debug\.png'
            $result | Should -Not -Match '<img'
        }

        It 'defaults CellStyle to SOLID' {
            $result = Format-HtmlCell -ImageSrc '/icons/x.png'
            $result | Should -Match 'STYLE="SOLID"'
        }
    }

    Context 'composability with Format-HtmlTable' {
        BeforeAll {
            . (Join-Path -Path $PrivateFolder -ChildPath 'Format-HtmlTable.ps1')
        }

        It 'output can be consumed directly by Format-HtmlTable' {
            $cells = Format-HtmlCell -Rows @('row1', 'row2')
            { Format-HtmlTable -TableRowContent $cells } | Should -Not -Throw
        }

        It 'resulting table contains the cell content' {
            $cells = Format-HtmlCell -Rows @('myvalue')
            $table = Format-HtmlTable -TableRowContent $cells
            $table | Should -Match 'myvalue'
            $table | Should -Match '^<TABLE\b.*>.*</TABLE>$'
        }
    }
}
