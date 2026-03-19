BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Remove-SpecialCharacter.ps1')
}

Describe Remove-SpecialCharacter {
    It 'Should return string without SpecialChar' {
        Remove-SpecialCharacter -String 'Problem&with()char' -SpecialChars '()[]{}&.' | Should -Be 'Problemwithchar'
    }
}