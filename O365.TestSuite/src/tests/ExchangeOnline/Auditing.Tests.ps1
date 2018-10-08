Describe "Admin audit log" -Tags 'Exchange Online', 'Auditing' {
    $AdminAuditLog = Get-EOLAdminAuditLogConfig

    It "Log is enabled" {
        $AdminAuditLog.AdminAuditLogEnabled | Should -Be $Test.Data.AdminAuditLogEnabled -Because (
            'The audit log should always be enabled')
    }


    It "Log age is set to at least $($Test.Data.AuditLogAgeLimit) days" {
        [int]$AdminAuditLog.AdminAuditLogAgeLimit.Split('.')[0] |
            Should -BeGreaterOrEqual $Test.Data.AuditLogAgeLimit -Because (
            'auditing logs should be available to view for a certain amount of days')
    }

    It "No data is excluded" {
        $AdminAuditLog.AdminAuditLogExcludedCmdlets | Should -Be $null -Because (
            'No data should be excluded from the audit log')

        $AdminAuditLog.AdminAuditLogCmdlets | Should -Be $Test.Data.AdminAuditLogCmdlets -Because (
            'all cmdlets should be audited in the audit log')

        $AdminAuditLog.AdminAuditLogParameters | Should -Be $Test.Data.AdminAuditLogParameters -Because (
            'all parameters should be audited in the audit log')
    }
}