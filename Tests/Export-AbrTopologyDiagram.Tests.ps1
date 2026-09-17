BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe Export-AbrTopologyDiagram {
    BeforeAll {
        $Diagram = New-AbrTopologyDiagram -Id 'UnitTest' -Title 'Unit Test Diagram'
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'Web01' -Label 'Web-Server-01' -Kind Server
        $Diagram = $Diagram | Add-AbrTopologyNode -Id 'App01' -Label 'App-Server-01' -Kind Application
        $Diagram = $Diagram | Add-AbrTopologyEdge -Id 'WebApp' -SourceId 'Web01' -TargetId 'App01' -Label 'HTTPS'
    }

    Context 'Format Parameter Tests' {
        It 'Should export a svg file' {
            $Result = $Diagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'UnitTestSvg' -Format 'svg'
            $Result.FullName | Should -Exist
        }

        It 'Should export a png file' {
            $Result = $Diagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'UnitTestPng' -Format 'png'
            $Result.FullName | Should -Exist
        }

        It 'Should export a html file' {
            $Result = $Diagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'UnitTestHtml' -Format 'html'
            $Result.FullName | Should -Exist
        }

        It 'Should return a base64 string' {
            $Result = $Diagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'UnitTestBase64' -Format 'base64'
            Test-AbrBase64 -String $Result | Should -BeTrue
        }

        It 'Should throw for an unsupported format' {
            { $Diagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'UnitTest' -Format 'dot' } | Should -Throw
        }
    }

    Context 'Svg content Tests' {
        It 'Should contain the diagram title' {
            $Result = $Diagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'UnitTestContent' -Format 'svg'
            $Content = Get-Content -Path $Result.FullName -Raw
            $Content | Should -Match 'Unit Test Diagram'
        }

        It 'Should contain the Web-Server-01 node label' {
            $Result = $Diagram | Export-AbrTopologyDiagram -OutputFolderPath $TestDrive -Filename 'UnitTestContent' -Format 'svg'
            $Content = Get-Content -Path $Result.FullName -Raw
            $Content | Should -Match 'Web-Server-01'
        }
    }
}
