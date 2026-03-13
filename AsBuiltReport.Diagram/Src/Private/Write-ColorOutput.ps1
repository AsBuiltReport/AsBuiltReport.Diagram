function Write-ColorOutput {
    <#
    .SYNOPSIS
        Used by AsBuiltReport.Diagram to output colored text.
    .DESCRIPTION
        Writes a string to the output stream using the specified foreground color.
        The original console foreground color is restored after output.
    .PARAMETER Color
        The foreground color to use when writing the string. Must be a valid ConsoleColor name (e.g. 'Red', 'Green', 'Cyan').
    .PARAMETER String
        The string to write to the output stream.
    .EXAMPLE
        Write-ColorOutput -Color 'Cyan' -String 'Hello, World!'
        Writes 'Hello, World!' in cyan text.
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .NOTES
        Version:        0.1.1
        Author:         Prateek Singh
    #>

    [CmdletBinding()]
    [OutputType([String])]

    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String] $Color,

        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String] $String
    )
    process {
        # save the current color
        $ForegroundColor = $Host.UI.RawUI.ForegroundColor

        # set the new color
        $Host.UI.RawUI.ForegroundColor = $Color

        # output
        if ($String) {
            Write-Output $String
        }

        # restore the original color
        $host.UI.RawUI.ForegroundColor = $ForegroundColor
    }
}