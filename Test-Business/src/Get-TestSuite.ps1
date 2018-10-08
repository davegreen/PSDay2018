function Get-TestSuite {
    <#
        .Synopsis
        Return available testsuite modules available on the system. If a path is specified,
        this path is also searched and any available testsuite modules imported.

        .Description
        Return available testsuite modules available on the system. If a path is specified,
        this path is also searched and any available testsuite modules imported.

        .Parameter Name
        Only return names like the one typed. Results are returned with the name Name*.TestSuite.

        .Parameter Path
        The path to search for a testsuite module.

        .Parameter All
        Return all versions, not just the latest one found for a particular module.

        .Parameter ListAvailable
        Check from all available modules, instead of modules loaded into the current session.

        .Example
        Get-TestSuite

        Outputs module data about test suite modules that have been discovered using names (for module directories),
        or though paths to a module *.psm1* or *.psd1*.

        .Notes
        Author: David Green
    #>

    [CmdletBinding(DefaultParameterSetName = 'Name')]
    Param (
        [Parameter(ParameterSetName = 'Name')]
        [string[]]
        $Name,

        [Parameter(
            ParameterSetName = 'Path',
            Mandatory
        )]
        [System.IO.FileInfo[]]
        $Path,

        [Parameter()]
        [switch]
        $ListAvailable,

        [Parameter()]
        [switch]
        $All
    )

    if (-not $Name) {
        $Name = '.'
    }

    if ($PSCmdlet.ParameterSetName -eq 'Name') {
        foreach ($TestSuite in $Name) {
            if ($TestSuite -match '\.TestSuite$') {
                $TestSuite = $TestSuite -replace '\.TestSuite$'
            }

            $Modules = Get-Module "*.TestSuite" -ErrorAction $ErrorActionPreference |
                Where-Object -Property Name -Match "$TestSuite\.*\.TestSuite$"

            if ((-not $Modules) -or $ListAvailable) {
                $Modules = Get-Module -ListAvailable "*.TestSuite" -ErrorAction $ErrorActionPreference |
                    Where-Object -Property Name -Match "$TestSuite\.*\.TestSuite$"
            }

            if ($All) {
                $Modules | Sort-Object -Property Version -Descending
            }
            else {
                $Modules = foreach ($Module in $Modules) {
                    $Modules | Where-Object Name -eq $Module.Name | Sort-Object -Property Version -Descending | Select-Object -First 1
                }
                
                $Modules | Select-Object -Unique
            }
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        if (Test-Path -Path $Path -PathType Container) {
            Import-Module $Path -PassThru -ErrorAction $ErrorActionPreference
        }
        else {
            Import-Module $Path -PassThru -ErrorAction $ErrorActionPreference
        }
    }
}