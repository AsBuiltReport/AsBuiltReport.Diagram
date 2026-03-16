function Split-ArrayElement {
    <#
    .SYNOPSIS
        Used by AsBuiltReport.Diagram to split an object into groups of arrays.
    .DESCRIPTION
        Splits an input array into a set of smaller sub-arrays. The split can be controlled either by specifying
        the number of parts to produce, or the maximum size of each part. If both are specified, 'size' takes precedence.
    .PARAMETER inArray
        The input array to be split into sub-arrays.
    .PARAMETER parts
        The number of parts to split the array into. Mutually exclusive with 'size'.
    .PARAMETER size
        The maximum number of elements in each part. Mutually exclusive with 'parts'.
    .EXAMPLE
        Split-ArrayElement -inArray @(1,2,3,4,5,6) -size 2
        Returns three sub-arrays: @(1,2), @(3,4), @(5,6).
    .EXAMPLE
        Split-ArrayElement -inArray @(1,2,3,4,5,6) -parts 3
        Returns three sub-arrays each containing two elements.
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .NOTES
        Version:        0.1.1
        Author:         Jonathan Colon
    #>

    [CmdletBinding()]
    param(
        $inArray,
        [int]$parts,
        [int]$size)
    process {
        if ($parts) {
            $PartSize = [Math]::Ceiling($inArray.count / $parts)
        }
        if ($size) {
            $PartSize = $size
            $parts = [Math]::Ceiling($inArray.count / $size)
        }

        $outArray = @()
        for ($i = 1; $i -le $parts; $i++) {
            $start = (($i - 1) * $PartSize)
            $end = (($i) * $PartSize) - 1
            if ($end -ge $inArray.count) {
                $end = $inArray.count
            }
            $outArray += , @($inArray[$start..$end])
        }
        return , $outArray
    }
}