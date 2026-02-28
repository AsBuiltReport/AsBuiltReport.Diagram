BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-DiaHtmlTableCell.ps1')
}

Describe 'Add-DiaHtmlTableCell' {
    Context 'PSCustomObject input' {
        BeforeAll {
            $ServerInfo = [PSCustomObject][ordered]@{
                'OS'     = 'Windows Server 2019'
                'CPU'    = '4 Cores'
                'Memory' = '16 GB'
            }
        }

        It 'Should return TR/TD rows for each property with default settings' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo
            $result | Should -BeExactly '<TR><TD PORT="OS" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">OS: Windows Server 2019</FONT></TD></TR><TR><TD PORT="CPU" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">CPU: 4 Cores</FONT></TD></TR><TR><TD PORT="Memory" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">Memory: 16 GB</FONT></TD></TR>'
        }

        It 'Should apply debug mode background color' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo -IconDebug $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
            $result | Should -Not -Match 'BGCOLOR="#FFFFFF"'
        }

        It 'Should apply custom alignment' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo -Align 'Left'
            $result | Should -Match 'ALIGN="Left"'
            $result | Should -Not -Match 'ALIGN="Center"'
        }

        It 'Should apply custom font size' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo -FontSize 18
            $result | Should -Match 'POINT-SIZE="18"'
            $result | Should -Not -Match 'POINT-SIZE="14"'
        }

        It 'Should apply custom cell background color' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo -CellBackgroundColor '#AABBCC'
            $result | Should -Match 'BGCOLOR="#AABBCC"'
        }

        It 'Should include property name as PORT attribute' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo
            $result | Should -Match 'PORT="OS"'
            $result | Should -Match 'PORT="CPU"'
            $result | Should -Match 'PORT="Memory"'
        }
    }

    Context 'OrderedDictionary input' {
        BeforeAll {
            $ServerInfo = [ordered]@{
                'OS'     = 'Windows Server 2019'
                'CPU'    = '4 Cores'
                'Memory' = '16 GB'
            }
        }

        It 'Should return TR/TD rows in order for each entry' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo
            $result | Should -BeExactly '<TR><TD PORT="OS" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">OS: Windows Server 2019</FONT></TD></TR><TR><TD PORT="CPU" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">CPU: 4 Cores</FONT></TD></TR><TR><TD PORT="Memory" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">Memory: 16 GB</FONT></TD></TR>'
        }

        It 'Should apply debug mode background color' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo -IconDebug $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
            $result | Should -Not -Match 'BGCOLOR="#FFFFFF"'
        }
    }

    Context 'Hashtable input' {
        BeforeAll {
            $ServerInfo = @{
                'OS' = 'Windows Server 2019'
            }
        }

        It 'Should return a TR/TD row for the key-value pair' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo
            $result | Should -BeExactly '<TR><TD PORT="OS" BGCOLOR="#FFFFFF" ALIGN="Center" colspan="1"><FONT POINT-SIZE="14">OS: Windows Server 2019</FONT></TD></TR>'
        }

        It 'Should apply debug mode background color' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo -IconDebug $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
        }

        It 'Should include key name in the cell text' {
            $result = Add-DiaHtmlTableCell -Rows $ServerInfo
            $result | Should -Match 'OS: Windows Server 2019'
        }
    }

    Context 'Object array input' {
        BeforeAll {
            $Servers = @(
                [PSCustomObject][ordered]@{ 'IP' = '192.168.1.1' },
                [PSCustomObject][ordered]@{ 'IP' = '192.168.1.2' }
            )
        }

        It 'Should return TR/TD rows for each object in the array' {
            $result = Add-DiaHtmlTableCell -Rows $Servers
            $result | Should -Match 'IP: 192.168.1.1'
            $result | Should -Match 'IP: 192.168.1.2'
        }

        It 'Should apply debug mode background color to all rows' {
            $result = Add-DiaHtmlTableCell -Rows $Servers -IconDebug $true
            $result | Should -Match 'BGCOLOR="#FFCCCC"'
            $result | Should -Not -Match 'BGCOLOR="#FFFFFF"'
        }
    }
}
