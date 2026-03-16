BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Get-RandomPastelColorInHex.ps1')
}

Describe Get-RandomPastelColorInHex {
    It 'Should return string type' {
        Get-RandomPastelColorInHex | Should -BeOfType String
    }
    It 'Should return a rgb color hex' {
        Get-RandomPastelColorInHex | Should -Match '^#[0-9A-F]{6}$'
    }
}
