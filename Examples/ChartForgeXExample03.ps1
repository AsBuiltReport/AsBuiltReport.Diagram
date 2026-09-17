<#
    ChartForgeX hierarchy counterpart to Example15.ps1. ParentId defines the infrastructure
    hierarchy while regular topology edges retain the connectivity labels from the original diagram.
#>
[CmdletBinding()]
param (
    [System.IO.FileInfo] $Path = '~\Desktop\',
    [ValidateSet('svg', 'png', 'html', 'bmp', 'gif', 'tiff', 'ppm', 'apng', 'base64')]
    [array] $Format = @('svg')
)

$OutputFolderPath = Resolve-Path -Path $Path

$Diagram = New-AbrTopologyDiagram -Id 'ChartForgeXExample03' -Title 'Web Application Diagram' -Subtitle '3 Tier Concept'

$Hierarchy = @(
    @{ Id = 'Wan'; Label = 'WAN'; Kind = 'Cloud'; Status = 'Unknown'; IconId = 'cloud' }
    @{ Id = 'Firewall'; Label = 'Firewall'; ParentId = 'Wan'; Kind = 'Gateway'; Status = 'Healthy'; IconId = 'firewall' }
    @{ Id = 'CoreRouter'; Label = 'Core-Router'; ParentId = 'Firewall'; Kind = 'Network'; Status = 'Healthy'; Subtitle = 'Cisco IOS 15.2'; IconId = 'router'; }
    @{ Id = 'Web01'; Label = 'Web-Server-01'; ParentId = 'CoreRouter'; Kind = 'Server'; Status = 'Healthy'; Subtitle = 'Redhat Linux 10'; IconId = 'server' }
    @{ Id = 'Web02'; Label = 'Web-Server-02'; ParentId = 'CoreRouter'; Kind = 'Server'; Status = 'Healthy'; Subtitle = 'Redhat Linux 10'; IconId = 'server' }
    @{ Id = 'Web03'; Label = 'Web-Server-03'; ParentId = 'CoreRouter'; Kind = 'Server'; Status = 'Healthy'; Subtitle = 'Ubuntu Linux 24'; IconId = 'server' }
    @{ Id = 'App01'; Label = 'App-Server-01'; ParentId = 'CoreRouter'; Kind = 'Application'; Status = 'Healthy'; Subtitle = 'Windows Server 2019'; IconId = 'server' }
    @{ Id = 'Db01'; Label = 'Db-Server-01'; ParentId = 'App01'; Kind = 'Database'; Status = 'Warning'; Subtitle = 'Oracle Server 8'; IconId = 'database' }
)

$Diagram = $Diagram | Add-AbrTopologyHierarchy -Item $Hierarchy -LayoutDirection TopToBottom -NodeDisplayMode Card -EdgeLength 200

$Legend = New-AbrTopologyLegend -Title 'Legend'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Server' -NodeKind Server -Color '#16A34A'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Database' -NodeKind Database -Color '#F97316'
$Legend = $Legend | Add-AbrTopologyLegendItem -Label 'Data Flow' -EdgeKind DataFlow -Color '#71797E'
$Diagram = $Diagram | Set-AbrTopologyLegend -Legend $Legend

$Diagram | Export-AbrTopologyDiagram -OutputFolderPath $OutputFolderPath -Filename 'ChartForgeXExample03' -Format $Format
