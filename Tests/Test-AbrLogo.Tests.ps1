BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Test-AbrImage.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Test-AbrLogo.ps1')
}

Describe Test-AbrLogo {
    BeforeAll {
        $IconPath = $TestDrive
        $Images = @{
            'Main_Logo' = 'AsBuiltReport.png'
        }
        $Logo = Join-Path -Path "$TestsFolder\Icons" -ChildPath 'Logo_Test.png'
        $ImageName = Test-AbrLogo -LogoPath $Logo -IconPath $IconPath -ImagesObj $Images
        $LogoPath = Join-Path -Path $IconPath -ChildPath 'Logo_Test.png'
    }

    It 'Should return Logo_Test.png string from Images hashtable' {
        $Images[$ImageName] | Should -Be 'Logo_Test.png'
    }
    It 'Verified if Logo_Test.png is inside TestDrive:\ folder' {
        $LogoPath | Should -Exist
    }
}