function Remove-SpecialChar {
    <#
    .SYNOPSIS
        Used by AsBuiltReport.Diagram to remove unsupported graphviz dot characters.
    .DESCRIPTION
        Removes special characters from a string that are not supported by Graphviz DOT notation.
        By default the characters ()[]{}&. are stripped. A custom set of characters can be provided
        via the SpecialChars parameter.
    .PARAMETER String
        The input string from which special characters will be removed.
    .PARAMETER SpecialChars
        A string containing the special characters to remove. Each character in this string is treated
        as an individual character to remove. Default is '()[]{}&.'.
    .EXAMPLE
        Remove-SpecialChar -String "Non Supported chars ()[]{}&."
        Returns 'Non Supported chars '
    .EXAMPLE
        Remove-SpecialChar -String "Hello.World" -SpecialChars '.'
        Returns 'HelloWorld'
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [string]$String,
        [string]$SpecialChars = '()[]{}&.'
    )
    process {
        if ($PSCmdlet.ShouldProcess($String, ('Remove {0} chars' -f $SpecialChars, $String))) {
            $String -replace $($SpecialChars.ToCharArray().ForEach( { [regex]::Escape($_) }) -join '|'), ''
        }
    }
}