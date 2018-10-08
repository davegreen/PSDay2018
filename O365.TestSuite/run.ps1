[CmdletBinding()]

Param (
    [Parameter()]
    [string[]]
    $Task = 'install',

    [Parameter()]
    [hashtable]
    $psakeParameters,

    # These parameters are for VSTS build automation use only. I would like to find another way to do this.
    [Parameter()]
    [string[]]
    $testCredential,

    [Parameter()]
    [string[]]
    $SPOCredential,

    [Parameter()]
    [string]
    $uploadURL
)

if ($testCredential -and $testCredential.Length -eq 2) {
    $testPass = ConvertTo-SecureString $testCredential[1] -AsPlainText -Force
    $testCred = New-Object System.Management.Automation.PSCredential ($testCredential[0], $testPass)
    Add-Setting -Key '365Admin' -Value $testCred -Path $env:TEMP\Setting.clixml -Verbose -ErrorAction SilentlyContinue
}

if ($SPOCredential -and $SPOCredential.Length -eq 2) {
    $SPOPass = ConvertTo-SecureString $SPOCredential[1] -AsPlainText -Force
    $SPOCred = New-Object System.Management.Automation.PSCredential ($SPOCredential[0], $SPOPass)
}

$psake = @{
    buildFile = "$PSScriptRoot\build.psake.ps1"
    taskList  = $Task
    Verbose   = $VerbosePreference
}

if ($psakeParameters) {
    $psake.parameters = $psakeParameters
}

Invoke-psake @psake
Install-Module -Name 'SharePointPnPPowerShellOnline' -Repository PSGallery -Force -Verbose -Scope CurrentUser -SkipPublisherCheck

if (Get-Module -Name 'O365.TestSuite' -ListAvailable) {
    Invoke-TestSuite -TestSuite O365.TestSuite -OutputPath $PSScriptRoot\Release\Results -NoSummary -Verbose
    Copy-Item -Path $PSScriptRoot\Release\Results\*\*.xml -Destination C:\inetpub\wwwroot -Force -Verbose
    Invoke-ReportUnit -Path C:\inetpub\wwwroot
    Compress-Archive -Path $PSScriptRoot\Release\Results -DestinationPath $PSScriptRoot\Release\$(Get-Date -Format FileDateTimeUniversal).zip -Verbose

    if ($uploadURL -and $SPOCred) {
        Connect-PnPOnline -Url $uploadURL -Credentials $SPOCred -Verbose
        Add-PnPFile -Path (Get-Item -Path $PSScriptRoot\Release\*.zip | Select-Object -First 1).FullName -Folder 'Shared Documents/General/Test-Example' -Verbose
    }

    if (Get-Setting -Key '365Admin' -Path $env:TEMP\Setting.clixml) {
        Remove-Setting -Key '365Admin' -Path $env:TEMP\Setting.clixml -Verbose
    }
}
else {
    throw 'test failure.'
}