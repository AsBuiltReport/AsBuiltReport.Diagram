BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-NodeCard.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Format-NodeObject.ps1')
}

Describe Add-NodeCard {
    BeforeAll {
        $Script:Card = Add-NodeCard -Name 'Web01' -Label 'Web-Server-01' -Subtitle 'Red Hat Linux 10' -AdditionalInfo ([ordered]@{
                IP   = '10.0.0.1'
                Role = 'Web'
            })
    }

    It 'Creates a rounded Graphviz HTML table' {
        $Card | Should -Match '^<TABLE PORT="EdgeDot" STYLE="ROUNDED" BORDER="1" CELLBORDER="0"'
    }

    It 'Renders a card title, subtitle, and metadata rows' {
        $Card | Should -Match '<B>Web-Server-01</B>'
        $Card | Should -Match 'Red Hat Linux 10'
        $Card | Should -Match 'IP: 10.0.0.1'
        $Card | Should -Match 'Role: Web'
    }

    It 'Escapes HTML-sensitive content' {
        $escapedCard = Add-NodeCard -Name 'Escaped' -Label 'App & API' -Subtitle 'Version <2>'

        $escapedCard | Should -Match 'App &amp; API'
        $escapedCard | Should -Match 'Version &lt;2&gt;'
    }
}
