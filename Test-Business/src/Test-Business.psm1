[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
$ModulePath = Resolve-Path -Path $PSScriptRoot

Get-ChildItem -Path $PSScriptRoot -Filter '*.ps1' | ForEach-Object {
    .$_.FullName
}

Get-ChildItem -Path $PSScriptRoot -Recurse -Filter '*.TestSuite.psd1' | ForEach-Object {
    Import-Module -Name $_.FullName
}