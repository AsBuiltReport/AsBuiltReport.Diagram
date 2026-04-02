BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'Add-AbrWatermarkToImage.ps1')
}

Describe Add-AbrWatermarkToImage {
    BeforeAll {
        $IconsPath = Join-Path -Path $TestsFolder -ChildPath 'Icons'
        $env:TMP = $TestDrive
        $GraphvizObj = 'digraph g {
            compound="true";
            "web1"->"database1"
            "web1"->"database2"
            "web2"->"database1"
            "web2"->"database2"
        }'
        $PassParamsNoDestinationPath = @{
            ImageInput = Join-Path -Path $IconsPath -ChildPath 'AsBuiltReport.png'
            WaterMarkText = 'Test'
            FontColor = 'Red'
        }
        $PassParamsNoFontColor = @{
            ImageInput = Join-Path -Path $IconsPath -ChildPath 'AsBuiltReport.png'
            WaterMarkText = 'Test'
        }
        $PassParamsDestinationPath = @{
            ImageInput = Join-Path -Path $IconsPath -ChildPath 'AsBuiltReport.png'
            DestinationPath = Join-Path -Path $IconsPath -ChildPath 'AsBuiltReportMarked.png'
            WaterMarkText = 'Test'
            FontColor = 'Red'
        }
        $PassParamsFontOpacity = @{
            ImageInput = Join-Path -Path $IconsPath -ChildPath 'AsBuiltReport.png'
            DestinationPath = Join-Path -Path $IconsPath -ChildPath 'AsBuiltReportMarked.png'
            WaterMarkText = 'Test'
            FontColor = 'Red'
            FontOpacity = 10
        }
        $FailParams = @{
            ImageInput = 'AsBuiltReport.png'
            DestinationPath = Join-Path -Path $TestDrive -ChildPath 'AsBuiltReportMarked.png'
            WaterMarkText = 'Test'
            FontColor = 'Red'
        }
    }

    It 'Should return Temporary path' {
        (Add-AbrWatermarkToImage @PassParamsNoDestinationPath).FullName | Should -Exist
    }
    It 'Should return AsBuiltReportMarked.png DestinationPath' {
        Add-AbrWatermarkToImage @PassParamsDestinationPath
        (Get-Item -Path $PassParamsDestinationPath.DestinationPath).FullName | Should -Exist
    }
    It 'Should return AsBuiltReportMarked.png with 20% opacity' {
        Add-AbrWatermarkToImage @PassParamsFontOpacity
        (Get-Item -Path $PassParamsFontOpacity.DestinationPath).FullName | Should -Exist
    }
    It 'Should work without FontColor parameter' {
        (Add-AbrWatermarkToImage @PassParamsNoFontColor).FullName | Should -Exist
    }
    It 'Should throw not found exception when ImageInput does not exist' {
        $scriptBlock = { Add-AbrWatermarkToImage @FailParams -ErrorAction Stop }
        $scriptBlock | Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'ImageInput'. File AsBuiltReport.png not found!"
    }
}

AfterAll {
    Remove-Item -Path (Join-Path -Path $ProjectRoot -ChildPath 'Tests\Icons\AsBuiltReportMarked.png') -Force -ErrorAction SilentlyContinue
}