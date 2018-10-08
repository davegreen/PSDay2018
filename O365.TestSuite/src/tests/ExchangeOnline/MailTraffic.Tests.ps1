Describe "Mail Traffic" -Tags 'Exchange Online', 'MailTraffic' {
    Context "Spam" {
        $MailTraffic = Get-EOLMailTrafficReport -Direction Inbound

        It "Percentage of blocked mail today under $($Test.Data.SpamDetectionThresholdPercentage)%" {
            $MailToday = $MailTraffic |
                Where-Object -Property Date -eq (Get-Date).ToUniversalTime().Date

            $MailSuccess = (($MailToday |
                        Where-Object -Property EventType -in -Value $Test.Data.StdMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            $MailFail = (($MailToday |
                        Where-Object -Property EventType -in -Value $Test.Data.MailTrafficBadStatus).MessageCount |
                    Measure-Object -Sum).Sum

            if ($MailFail -gt 0) {
                $MailFail / ($MailFail + $MailSuccess) * 100 |
                    Should -BeLessOrEqual $Test.Data.SpamDetectionThresholdPercentage
            }
            else {
                $MailSuccess | Should -BeGreaterOrEqual $MailFail
            }
        }

        It "Percentage of blocked mail yesterday under $($Test.Data.SpamDetectionThresholdPercentage)%" {
            $MailToday = $MailTraffic |
                Where-Object -Property Date -eq (Get-Date).ToUniversalTime().AddDays(-1).Date

            $MailSuccess = (($MailToday |
                        Where-Object -Property EventType -in -Value $Test.Data.StdMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            $MailFail = (($MailToday |
                        Where-Object -Property EventType -in -Value $Test.Data.MailTrafficBadStatus).MessageCount |
                    Measure-Object -Sum).Sum

            if ($MailFail -gt 0) {
                $MailFail / ($MailFail + $MailSuccess) * 100 |
                    Should -BeLessOrEqual $Test.Data.SpamDetectionThresholdPercentage
            }
            else {
                $MailSuccess | Should -BeGreaterOrEqual $MailFail
            }
        }

        It "Percentage of blocked mail this week under $($Test.Data.SpamDetectionThresholdPercentage)%" {
            $MailToday = $MailTraffic |
                Where-Object -Property Date -gt (Get-Date).ToUniversalTime().AddDays(-7).Date

            $MailSuccess = (($MailToday |
                        Where-Object -Property EventType -in -Value $Test.Data.StdMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            $MailFail = (($MailToday |
                        Where-Object -Property EventType -in -Value $Test.Data.MailTrafficBadStatus).MessageCount |
                    Measure-Object -Sum).Sum

            if ($MailFail -gt 0) {
                $MailFail / ($MailFail + $MailSuccess) * 100 |
                    Should -BeLessOrEqual $Test.Data.SpamDetectionThresholdPercentage
            }
            else {
                $MailSuccess | Should -BeGreaterOrEqual $MailFail
            }
        }
    }

    Context "Malware" {
        $MailATP = Get-EOLMailTrafficATPReport

        It "Percentage of ATP detections today under $($Test.Data.ATPDetectionThresholdPercentage)%" {
            $MailATPToday = $MailATP |
                Where-Object -Property Date -eq (Get-Date).ToUniversalTime().Date

            $ATPSuccess = (($MailATPToday |
                        Where-Object -Property EventType -eq -Value $Test.Data.ATPMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            $ATPFail = (($MailATPToday |
                        Where-Object -Property EventType -ne -Value $Test.Data.ATPMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            if ($ATPFail -gt 0) {
                $ATPFail / $ATPSuccess * 100 |
                    Should -BeLessOrEqual $Test.Data.ATPDetectionThresholdPercentage
            }
            else {
                $ATPSuccess | Should -BeGreaterOrEqual $ATPFail
            }
        }

        It "Percentage of ATP detections yesterday under $($Test.Data.ATPDetectionThresholdPercentage)%" {
            $MailATPYDay = $MailATP |
                Where-Object -Property Date -eq (Get-Date).ToUniversalTime().AddDays(-1).Date

            $ATPSuccess = (($MailATPYDay |
                        Where-Object -Property EventType -eq -Value $Test.Data.ATPMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            $ATPFail = (($MailATPYDay |
                        Where-Object -Property EventType -ne -Value $Test.Data.ATPMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            if ($ATPFail -gt 0) {
                $ATPFail / $ATPSuccess * 100 |
                    Should -BeLessOrEqual $Test.Data.ATPDetectionThresholdPercentage
            }
            else {
                $ATPSuccess | Should -BeGreaterOrEqual $ATPFail
            }
        }

        It "Percentage of ATP detections this week under $($Test.Data.ATPDetectionThresholdPercentage)%" {
            $MailATPWeek = $MailATP |
                Where-Object -Property Date -gt (Get-Date).ToUniversalTime().AddDays(-7).Date

            $ATPSuccess = (($MailATPWeek |
                        Where-Object -Property EventType -eq -Value $Test.Data.ATPMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            $ATPFail = (($MailATPWeek |
                        Where-Object -Property EventType -ne -Value $Test.Data.ATPMailPassStatus).MessageCount |
                    Measure-Object -Sum).Sum

            if ($ATPFail -gt 0) {
                $ATPFail / $ATPSuccess * 100 |
                    Should -BeLessOrEqual $Test.Data.ATPDetectionThresholdPercentage
            }
            else {
                $ATPSuccess | Should -BeGreaterOrEqual $ATPFail
            }
        }
    }
}