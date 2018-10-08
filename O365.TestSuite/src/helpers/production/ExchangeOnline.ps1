function Connect-ExchangeOnline {
    [CmdletBinding(DefaultParameterSetName = 'AllowClobber')]
    Param (
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential,

        [Parameter(
            ParameterSetName = 'Prefix'
        )]
        [switch]
        $Prefix,

        [Parameter(
            ParameterSetName = 'AllowClobber'
        )]
        [bool]
        $AllowClobber = $true,

        [Parameter()]
        [ValidateSet(
            'EOL',
            'EOP',
            'Compliance'
        )]
        [string]
        $Connection = 'EOL'
    )

    $Uri = switch ($Connection) {
        'EOL' { 'https://outlook.com/powershell-liveid' }
        'EOP' { 'https://ps.protection.outlook.com/powershell-liveid/' }
        'Compliance' { 'https://ps.compliance.protection.outlook.com/powershell-liveid/' }
    }

    try {
        $Session = @{
            ConfigurationName = 'Microsoft.Exchange'
            ConnectionUri     = $Uri
            Credential        = $Credential
            Authentication    = 'basic'
            AllowRedirection  = $true
        }

        $Import = @{
            Session = (New-PSSession @Session)
        }

        if ($Prefix) {
            Import-Module (Import-PSSession @Import -AllowClobber:$AllowClobber) -Global -Prefix $Connection -ErrorAction Stop
        }
        else {
            Import-Module (Import-PSSession @Import -AllowClobber:$AllowClobber) -Global -ErrorAction Stop
        }
    }
    catch {
        Write-Error "Cannot connect or invalid credentials. Please try again."
    }
}

if ($Test.Data) {
    try {
        $ModuleDescription = "Implicit remoting for $($Test.Data.ConnectURI)"
        $CommandSrc = Get-Command Get-EOLMailbox -ErrorAction SilentlyContinue

        $null = Get-Command -Name 'Get-EOLMailbox' -ErrorAction Stop

        if (-not (Get-Module | Where-Object -Property Description -eq -Value $ModuleDescription)) {
            throw
        }

        if ($CommandSrc -and ((Get-Module $CommandSrc.Source).Description -ne $ModuleDescription)) {
            Remove-Module $CommandSrc.Source -ErrorAction SilentlyContinue
            throw
        }
    }
    catch {
        $Credential = Get-Credential
        Connect-ExchangeOnline -Credential $Credential -Prefix
    }
}
else {
    throw "Exchange Online data not found. Tests skipped."
}