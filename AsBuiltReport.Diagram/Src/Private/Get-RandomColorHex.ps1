function Get-RandomColorHex {
    <#
    .SYNOPSIS
        Generates a random color in hexadecimal format.
    .DESCRIPTION
        Used by AsBuiltReport.Diagram to generate a random RGB color represented as a hex string (e.g. #A3F2C1).
        Each color channel (Red, Green, Blue) is independently randomized across the full range 0-255.
    .EXAMPLE
        Get-RandomColorHex
        Returns a string such as '#3AF21B'.
    .OUTPUTS
        System.String
    .NOTES
        Version:        0.1.2
        Author:         Jonathan Colon
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    # Generate random values for Red, Green, and Blue components (0-255)
    $red = Get-Random -Minimum 0 -Maximum 255
    $green = Get-Random -Minimum 0 -Maximum 255
    $blue = Get-Random -Minimum 0 -Maximum 255

    # Convert each component to a two-digit hexadecimal string
    $hexRed = '{0:X2}' -f $red
    $hexGreen = '{0:X2}' -f $green
    $hexBlue = '{0:X2}' -f $blue

    # Combine the hexadecimal components into a full color string
    $hexColor = "#$hexRed$hexGreen$hexBlue"

    return $hexColor
}