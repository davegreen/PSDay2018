# Some manifest settings are managed automatically, these are:
# Path
# RootModule
# FileList
# FunctionsToExport
# CmdletsToExport
# AliasesToExport
# ReleaseNotes
# VariablesToExport? (Not implemented yet).

@{
    Description       = 'A PowerShell script module containing an Office 365 test suite for use with the Test-Business module.'
    Author            = 'David Green'
    CompanyName       = 'N/A'
    Copyright         = '(c) 2018. All rights reserved.'
    PowerShellVersion = '5.1'
    ModuleVersion     = '1.7.5'
    RequiredModules   = 'Pester', 'AzureAD', 'MSOnline', 'Test-Business'
    Tags              = 'O365.TestSuite', 'Office 365'
    # LicenseUri        = ''
    # ProjectUri        = ''
    # IconUri           = ''
}