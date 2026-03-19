BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Get-RandomColorInHex.ps1')
}

Describe Get-RandomColorInHex {
    It 'Should return string type' {
        Get-RandomColorInHex | Should -BeOfType String
    }
    It 'Should return a rgb color hex' {
        Get-RandomColorInHex | Should -Match '^#[0-9A-F]{6}$'
    }
}
