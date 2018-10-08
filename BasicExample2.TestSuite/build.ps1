[CmdletBinding()]

Param (
    [Parameter()]
    [string[]]
    $Task = 'build',

    [Parameter()]
    [hashtable]
    $psakeParameters
)

$psake = @{
    buildFile = "$PSScriptRoot\build.psake.ps1"
    taskList  = $Task
    Verbose   = $VerbosePreference
}

if ($psakeParameters) {
    $psake.parameters = $psakeParameters
}

Invoke-psake @psake