if ($Test.Data) {
    Remove-Module -Name MSOnline -ErrorAction SilentlyContinue

    try {
        $Splat = @{
            Key     = $Test.Data.ConnectCredentials.Key
            Message = $Test.Data.ConnectCredentials.Message
        }

        $null = Connect-MsolService -Credential (Get-Credential)
    }
    catch {
        $null = Connect-MsolService
    }
}
else {
    throw "DirectorySync data not found. Tests skipped."
}