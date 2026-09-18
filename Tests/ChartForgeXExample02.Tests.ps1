BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath '_InitializeTests.ps1')
}

Describe ChartForgeXExample02 {
    Context 'Format Parameter Tests' {
        It 'Should exist ChartForgeXExample02.svg' {
            $PassParamsSvg = @{
                Path   = $TestDrive
                Format = @('svg')
            }
            (& $ProjectRoot\Examples\ChartForgeXExample02.ps1 @PassParamsSvg).FullName | Should -Exist
        }

        It 'Should exist ChartForgeXExample02.png' {
            $PassParamsPng = @{
                Path   = $TestDrive
                Format = @('png')
            }
            (& $ProjectRoot\Examples\ChartForgeXExample02.ps1 @PassParamsPng).FullName | Should -Exist
        }

        It 'Should return error about unsupported Format' {
            $PassParamsBad = @{
                Path   = $TestDrive
                Format = @('dot')
            }
            { & $ProjectRoot\Examples\ChartForgeXExample02.ps1 @PassParamsBad } | Should -Throw
        }
    }

    Context 'Svg content Tests' {
        BeforeAll {
            $PassParamsSvg = @{
                Path   = $TestDrive
                Format = @('svg')
            }
            $RunFile = & $ProjectRoot\Examples\ChartForgeXExample02.ps1 @PassParamsSvg
            $SvgContent = Get-Content -Path ($RunFile).FullName -Raw
        }

        It 'Should match the diagram title' {
            $SvgContent | Should -Match 'Web Application Diagram'
        }

        It 'Should match the Web Server Farm group' {
            $SvgContent | Should -Match 'Web Server Farm'
        }

        It 'Should match Web-Server-01, Web-Server-02 and Web-Server-03 nodes' {
            $SvgContent | Should -Match 'Web-Server-01'
            $SvgContent | Should -Match 'Web-Server-02'
            $SvgContent | Should -Match 'Web-Server-03'
        }

        It 'Should render the Web Server Farm group box so it fully encloses all three web server nodes' {
            # Regression test: ChartForgeX's group rectangle does not always auto-fit to its members.
            # With the 'Layered' layout mode, a too-narrow group -Width lets sibling nodes (which fan
            # out to a shared external node) spread outside the box; conversely, a box widened just to
            # chase that spread can grow tall enough to swallow unrelated nodes from other tiers. The
            # 'GroupGrid' -LayoutMode (used by this example) avoids both failure modes by auto-sizing
            # the group to its own members only.
            $GroupMatch = [regex]::Match($SvgContent, '<rect class="cfx-topology__group-card" x="([\d.]+)" y="([\d.]+)" width="([\d.]+)" height="([\d.]+)"')
            $GroupMatch.Success | Should -BeTrue

            $GroupX = [double]$GroupMatch.Groups[1].Value
            $GroupY = [double]$GroupMatch.Groups[2].Value
            $GroupWidth = [double]$GroupMatch.Groups[3].Value
            $GroupHeight = [double]$GroupMatch.Groups[4].Value

            foreach ($NodeId in @('Web01', 'Web02', 'Web03')) {
                $NodeMatch = [regex]::Match($SvgContent, "-node-$NodeId`"[\s\S]*?<rect class=`"cfx-topology__node-card`" x=`"([\d.]+)`" y=`"([\d.]+)`" width=`"([\d.]+)`" height=`"([\d.]+)`"")
                $NodeMatch.Success | Should -BeTrue

                $NodeX = [double]$NodeMatch.Groups[1].Value
                $NodeY = [double]$NodeMatch.Groups[2].Value
                $NodeWidth = [double]$NodeMatch.Groups[3].Value
                $NodeHeight = [double]$NodeMatch.Groups[4].Value

                $NodeX | Should -BeGreaterOrEqual $GroupX
                $NodeY | Should -BeGreaterOrEqual $GroupY
                ($NodeX + $NodeWidth) | Should -BeLessOrEqual ($GroupX + $GroupWidth)
                ($NodeY + $NodeHeight) | Should -BeLessOrEqual ($GroupY + $GroupHeight)
            }
        }

        It 'Should not enclose nodes from other tiers inside the Web Server Farm group box' {
            $GroupMatch = [regex]::Match($SvgContent, '<rect class="cfx-topology__group-card" x="([\d.]+)" y="([\d.]+)" width="([\d.]+)" height="([\d.]+)"')
            $GroupMatch.Success | Should -BeTrue

            $GroupX = [double]$GroupMatch.Groups[1].Value
            $GroupY = [double]$GroupMatch.Groups[2].Value
            $GroupWidth = [double]$GroupMatch.Groups[3].Value
            $GroupHeight = [double]$GroupMatch.Groups[4].Value

            foreach ($NodeId in @('App01', 'Db01', 'CoreRouter', 'Firewall', 'Wan')) {
                $NodeMatch = [regex]::Match($SvgContent, "-node-$NodeId`"[\s\S]*?<rect class=`"cfx-topology__node-card`" x=`"([\d.]+)`" y=`"([\d.]+)`" width=`"([\d.]+)`" height=`"([\d.]+)`"")
                $NodeMatch.Success | Should -BeTrue

                $NodeX = [double]$NodeMatch.Groups[1].Value
                $NodeY = [double]$NodeMatch.Groups[2].Value
                $NodeWidth = [double]$NodeMatch.Groups[3].Value
                $NodeHeight = [double]$NodeMatch.Groups[4].Value

                # The node rectangle must be fully outside the group box on at least one axis.
                $IsOutside = ($NodeX + $NodeWidth) -le $GroupX -or $NodeX -ge ($GroupX + $GroupWidth) -or
                    ($NodeY + $NodeHeight) -le $GroupY -or $NodeY -ge ($GroupY + $GroupHeight)
                $IsOutside | Should -BeTrue
            }
        }

        It 'Should match App-Server-01 node' {
            $SvgContent | Should -Match 'App-Server-01'
        }

        It 'Should match Db-Server-01 node' {
            $SvgContent | Should -Match 'Db-Server-01'
        }

        It 'Should match Core-Router node' {
            $SvgContent | Should -Match 'Core-Router'
        }

        It 'Should match WAN node' {
            $SvgContent | Should -Match 'WAN'
        }

        It 'Should match Firewall node' {
            $SvgContent | Should -Match 'Firewall'
        }

        It 'Should match the gRPC edge label' {
            $SvgContent | Should -Match 'gRPC'
        }

        It 'Should match the SQL edge label' {
            $SvgContent | Should -Match 'SQL'
        }

        It 'Should match the Legend title' {
            $SvgContent | Should -Match 'Legend'
        }
    }
}
