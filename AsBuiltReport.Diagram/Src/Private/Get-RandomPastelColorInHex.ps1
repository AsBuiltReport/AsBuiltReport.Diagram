function Get-RandomPastelColorInHex {
    <#
    .SYNOPSIS
        Generates a random pastel color in hexadecimal format.
    .DESCRIPTION
        Used by AsBuiltReport.Diagram to generate a random pastel RGB color represented as a hex string (e.g. #D3F2C1).
        Each color channel (Red, Green, Blue) is independently randomized in the pastel range 127-255,
        ensuring a consistently light and soft color palette.
    .EXAMPLE
        Get-RandomPastelColorInHex
        Returns a string such as '#C3F21B'.
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

    # Generate random values for Red, Green, and Blue components (pastel: 127-255)
    $red = Get-Random -Minimum 127 -Maximum 255
    $green = Get-Random -Minimum 127 -Maximum 255
    $blue = Get-Random -Minimum 127 -Maximum 255

    # Convert each component to a two-digit hexadecimal string
    $hexRed = '{0:X2}' -f $red
    $hexGreen = '{0:X2}' -f $green
    $hexBlue = '{0:X2}' -f $blue

    # Combine the hexadecimal components into a full color string
    $hexColor = "#$hexRed$hexGreen$hexBlue"

    return $hexColor
}