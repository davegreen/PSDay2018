if ($Test.Data) {
    Remove-Module -Name AzureAD -ErrorAction SilentlyContinue

    $Splat = @{
        Key = $Test.Data.ConnectCredentials.Key
        Message = $Test.Data.ConnectCredentials.Message
    }

    try {
        $null = Connect-AzureAD -Credential (Get-Credential)
    }
    catch {
        $null = Connect-AzureAD
    }
}
else {
    throw "AzureAD data not found. Tests skipped."
}