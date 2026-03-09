function Get-NodeIP {
    <#
    .SYNOPSIS
        Used by AsBuiltReport.Diagram to translate node name to an network ip address type object.
    .DESCRIPTION
        Resolves the given hostname to an IP address string using DNS. IPv4 addresses are preferred;
        IPv6 is used as a fallback. Returns 'Unknown' if the hostname cannot be resolved.
    .PARAMETER Hostname
        The hostname or FQDN to resolve to an IP address.
    .EXAMPLE
        Get-NodeIP -Hostname 'localhost'
        Returns '127.0.0.1'
    .EXAMPLE
        Get-NodeIP -Hostname 'invalid-host'
        Returns 'Unknown'
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.Diagram
    .NOTES
        Version:        0.2.27
        Author:         Jonathan Colon
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [string]$Hostname
    )
    process {
        try {
            try {
                if ('InterNetwork' -in [System.Net.Dns]::GetHostAddresses($Hostname).AddressFamily) {
                    $IPADDR = ([System.Net.Dns]::GetHostAddresses($Hostname) | Where-Object { $_.AddressFamily -eq 'InterNetwork' })[0].IPAddressToString
                } elseif ('InterNetworkV6' -in [System.Net.Dns]::GetHostAddresses($Hostname).AddressFamily) {
                    $IPADDR = ([System.Net.Dns]::GetHostAddresses($Hostname) | Where-Object { $_.AddressFamily -eq 'InterNetworkV6' })[0].IPAddressToString
                } else {
                    $IPADDR = $Null
                }
            } catch {
                Write-Verbose -Message "Unable to resolve Hostname Address: $Hostname"
                $IPADDR = $Null
            }
            $NodeIP = switch ([string]::IsNullOrEmpty($IPADDR)) {
                $true { 'Unknown' }
                $false { $IPADDR }
                default { $Hostname }
            }
        } catch {
            Write-Verbose -Message $_.Exception.Message
        }

        return $NodeIP
    }
}