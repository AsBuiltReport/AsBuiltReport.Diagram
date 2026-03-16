BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Get-AbrNodeIP.ps1')
}

Describe Get-AbrNodeIP {
    It 'Should return Host IP Address' {
        Get-AbrNodeIP -Hostname localhost | Should -Be '127.0.0.1'
    }
    It 'Should return Unknown' {
        Get-AbrNodeIP -Hostname 'invalid-hostname' | Should -Be 'Unknown'
    }
}