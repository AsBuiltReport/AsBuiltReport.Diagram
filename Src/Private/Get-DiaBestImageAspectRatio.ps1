function Get-DiaBestImageAspectRatio {
    <#
    .SYNOPSIS
        Used by As Built Report to get base64 image best aspect ratio based in maxWidth or maxHeight.
    .DESCRIPTION
        This allow the diagram image to fit the report page margins
    .NOTES
        Version:        0.2.39
        Author:         Jonathan Colon
    .EXAMPLE
        Get-DiaBestImageAspectRatio -ImageInput "C:\Images\diagram.png" -MaxWidth 800 -MaxHeight 600

        Returns the best aspect ratio for the specified image based on the maximum width and height.
    .LINK
        https://github.com/rebelinux/Diagrammer.Core
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter (
            Position = 0,
            Mandatory = $false,
            HelpMessage = 'Please provide Graphviz object'
        )]
        [string] $GraphObj,
        [Parameter(
            Position = 1,
            Mandatory = $false,
            HelpMessage = 'Please provide image file path'
        )]
        [ValidateScript( {
                if (Test-Path -Path $_) {
                    $true
                } else {
                    throw "File $_ not found!"
                }
            })]
        [string] $ImageInput,

        [Parameter (
            Mandatory = $false,
            HelpMessage = 'Set the image maximun Width value'
        )]
        [int] $MaxWidth,

        [Parameter (
            Mandatory = $false,
            HelpMessage = 'Set the image maximun Height value'
        )]
        [int] $MaxHeight

    )

    begin {
        # Validate mandatory parameters
        if ((-not $PSBoundParameters.ContainsKey('ImageInput')) -and (-not $PSBoundParameters.ContainsKey('GraphObj'))) {
            throw 'Error: Please provide a image path or a graphviz string to process.'
        }
        try {
            Add-Type -AssemblyName System.Drawing -ErrorAction Stop
            Write-Verbose -Message 'System.Drawing assembly loaded successfully.'
        } catch {
            throw 'These functions require the [System.Drawing.Color] .NET Class. Assembly could not be loaded.'
        }
    }
    process {

        if ($GraphObj) {
            $ImagePrty = @{}
            $Image = @{
                Width = 0
                Height = 0
            }
            switch ($PSVersionTable.Platform) {
                'Unix' {
                    & {
                        try {
                            $Image.Width = Get-ImageWidthFromBase64 -Base64 $GraphObj
                            $Image.Height = Get-ImageHeightFromBase64 -Base64 $GraphObj
                        } catch {
                            throw 'Unable to convert Graphviz object to base64 format needed to get image dimensions'
                        }
                    }
                }
                default {
                    try {
                        $Image = [System.Drawing.Image]::FromStream((New-Object System.IO.MemoryStream(, [convert]::FromBase64String($GraphObj))))
                    } catch {
                        throw 'Unable to convert Graphviz object to base64 format needed to get image dimensions'
                    }
                }
            }
        } else {
            $ImagePrty = @{}
            try {
                $Image = @{
                    Width = 0
                    Height = 0
                }
                switch ($PSVersionTable.Platform) {
                    'Unix' {
                        & {
                            try {
                                $Image.Width = Get-ImageWidthFromFile((Get-ChildItem -Path $ImageInput).FullName)
                                $Image.Height = Get-ImageHeightFromFile((Get-ChildItem -Path $ImageInput).FullName)
                            } catch {
                                throw 'Unable to read image dimensions from file'
                            }
                        }
                    }
                    default {
                        $Image = [System.Drawing.Image]::FromFile((Get-ChildItem -Path $ImageInput).FullName)
                    }
                }
            } catch {
                Write-Verbose -Message 'Unable to read image dimensions from file'
                Write-Debug -Message $($_.Exception.Message)
            }
        }

        if ($Image) {

            $originalWidth = $Image.Width
            $originalHeight = $Image.Height
            $aspectRatio = $originalWidth / $originalHeight

            # Determine new dimensions based on constraints
            if ($MaxWidth -and $originalWidth -gt $MaxWidth) {
                $newWidth = $MaxWidth
                $newHeight = [int]($newWidth / $aspectRatio)
            } elseif ($MaxHeight -and $originalHeight -gt $MaxHeight) {
                $newHeight = $MaxHeight
                $newWidth = [int]($newHeight * $aspectRatio)
            } else {
                $newWidth = $originalWidth
                $newHeight = $originalHeight
            }

            $ImagePrty = @{
                'Width' = $newWidth
                'Height' = $newHeight
            }

            return $ImagePrty
        } else {
            Write-Verbose -Message 'Unable to validate image dimensions'
        }
    }

    end {}

} # end