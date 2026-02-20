function ConvertTo-Pdf-WaterMark {
    <#
    .SYNOPSIS
        Function to export diagram to pdf format.
    .DESCRIPTION
        Export a diagram in PDF/PNG/SVG formats using PSgraph.
    .NOTES
        Version:        0.2.34
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux
    .LINK
        https://github.com/rebelinux/Diagrammer.Core
    #>
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = 'Please provide image file path'
        )]
        [ValidateScript( {
                if (Test-Path -Path $_) {
                    $true
                } else {
                    throw "File $_ not found!"
                }
            })]
        [System.IO.FileInfo] $ImageInput,
        [Parameter(
            Position = 1,
            Mandatory = $true,
            HelpMessage = 'Please provide the path to the image output file'
        )]
        [ValidateScript({
                $parentPath = Split-Path -Path $_ -Parent
                if (-not ($parentPath | Test-Path) ) {
                    throw 'Folder does not exist'
                }
                return $true
            })]
        [String]$DestinationPath
    )
    process {
        try {
            Write-Verbose -Message "Trying to convert $($ImageInput.Name) object to PDF format. Destination Path: $DestinationPath."
            switch ($PSVersionTable.PSEdition) {
                'Core' {
                    # Net 9.0 assembly call
                    Write-Verbose -Message 'Successfully loaded the .Net 9.0 assembly for PDF conversion.'
                    # Get assemblies files and import them
                    $assemblyName = switch ($PSVersionTable.PSEdition) {
                        'Core' {
                            @(Get-ChildItem -Path ("$PSScriptRoot{0}Src{0}Bin{0}Assemblies{0}net90{0}*.dll" -f [System.IO.Path]::DirectorySeparatorChar) -ErrorAction SilentlyContinue)
                        }
                        'Desktop' {
                            @(Get-ChildItem -Path ("$PSScriptRoot{0}Src{0}Bin{0}Assemblies{0}net48{0}*.dll" -f [System.IO.Path]::DirectorySeparatorChar) -ErrorAction SilentlyContinue)
                        }
                        default {
                            @()
                        }
                    }

                    $loadedassemblies = [System.AppDomain]::CurrentDomain.GetAssemblies().ManifestModule.Name

                    foreach ($Assembly in $assemblyName) {
                        if ($Assembly.Name -notin $loadedassemblies) {
                            try {
                                Write-Verbose -Message "Loading assembly '$($Assembly.Name)'."
                                Add-Type -Path $Assembly.FullName -Verbose
                            } catch {
                                Write-Error -Message "Failed to add assembly $($Assembly.FullName): $_"
                            }
                        }
                    }
                    $Null = [Diagrammer.ConvertImageToPDF]::ConvertPngToPdf($ImageInput.FullName, $DestinationPath)
                }
                'Desktop' {
                    Write-Verbose -Message 'Successfully loaded the .Net 4.8 assembly for PDF conversion.'
                    # Net 4.8 assembly call
                    $Null = [DiaConvertImageToPDF.ConvertImageToPDF]::ConvertPngToPdf($ImageInput.FullName, $DestinationPath)
                }
                default {
                    Write-Verbose -Message 'Successfully loaded the .Net 4.8 assembly for PDF conversion.'
                    # Net 4.8 assembly call (Fucking shit)
                    $Null = [DiaConvertImageToPDF.ConvertImageToPDF]::ConvertPngToPdf($ImageInput.FullName, $DestinationPath)
                }
            }

        } catch {
            Write-Verbose -Message "Unable to convert $($ImageInput.Name) object to PDF format."
            Write-Debug -Message $($_.Exception.Message)
        }
        if (Test-Path -Path $DestinationPath) {
            Write-Verbose -Message "Successfully converted $($ImageInput.Name) object to PDF format. Saved Path: $DestinationPath."
            Get-ChildItem -Path $DestinationPath
        }
    }
    end {}
}