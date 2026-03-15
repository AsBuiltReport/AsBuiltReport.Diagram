function Group-AbrNode {
    <#
    .SYNOPSIS
        Function to split node array
    .DESCRIPTION
        Splits an array of nodes into groups and creates Graphviz edges connecting consecutive groups.
        Used to produce chain-style node connections in diagram layouts.
    .NOTES
        Version:        0.1.8
        Author:         Jonathan Colon
        Bluesky:        @jcolonfpr.bsky.social
        Github:         rebelinux
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ScriptBlock])]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = 'Please provide the objects to process'
        )]
        [Array] $InputObject,
        [Parameter(
            Position = 1,
            Mandatory = $true,
            HelpMessage = 'Number of nodes per group when splitting the input array'
        )]
        [int] $SplitinGroups,
        [Parameter(
            Position = 2,
            Mandatory = $true,
            HelpMessage = 'The style of the edges connecting the node groups (e.g. dashed, solid)'
        )]
        [string] $Style,
        [Parameter(
            Position = 3,
            Mandatory = $true,
            HelpMessage = 'The color of the edges connecting the node groups'
        )]
        [string] $Color,
        [Parameter(
            Position = 4,
            Mandatory = $false,
            HelpMessage = 'The minimum edge length between node groups'
        )]
        [string] $Minlen = 1
    )
    process {
        $Output = & {
            $Group = Split-ArrayElement -inArray $InputObject -size $SplitinGroups
            $Start = 0
            $LocalPGNum = 1
            while ($LocalPGNum -ne $Group.Length) {
                Edge -From $Group[$Start] -To $Group[$LocalPGNum] @{minlen = $Minlen; style = $Style; color = $Color }
                $Start++
                $LocalPGNum++
            }
        }
        return $Output
    }
    end {}
}