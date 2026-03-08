BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
    . (Join-Path -Path $PrivateFolder -ChildPath 'ConvertTo-Svg.ps1')
}

Describe ConvertTo-Svg {
    BeforeAll {
        $GraphvizObj = 'digraph g {
            compound="true";
            "web1"->"database1"
            "web1"->"database2"
            "web2"->"database1"
            "web2"->"database2"
        }'
        $PassParams = @{
            GraphObj = $GraphvizObj
            DestinationPath = Join-Path $TestDrive 'output.svg'
        }
        $PassParamsWatermark = @{
            GraphObj = $GraphvizObj
            DestinationPath = Join-Path $TestDrive 'output-watermark.svg'
            WaterMarkText = 'Confidential'
            WaterMarkColor = 'DarkGray'
            WaterMarkFontOpacity = 40
        }
        $FailParams = @{
            GraphObj = $GraphvizObj
            DestinationPath = 'TestDriv:\output.svg'
        }
    }

    It 'Should return output.svg path' {
        (ConvertTo-Svg @PassParams).FullName | Should -Exist
    }
    It 'Should Not return output.svg path' {
        $scriptBlock = { ConvertTo-Svg @FailParams }
        $scriptBlock | Should -Not -Exist
    }

    It 'Should include watermark text in svg output' {
        if (-not (Get-Command -Name Add-WatermarkToSvg -ErrorAction SilentlyContinue)) {
            Set-ItResult -Skipped -Because 'Add-WatermarkToSvg cmdlet is not available in the loaded AsBuiltReport.Diagram assembly.'
        }
        $result = ConvertTo-Svg @PassParamsWatermark
        $result.FullName | Should -Exist
        (Get-Content -Path $result.FullName -Raw) | Should -Match 'Confidential'
    }
}