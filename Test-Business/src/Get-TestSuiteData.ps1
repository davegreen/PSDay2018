function Get-TestSuiteData {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string[]]
        $TestSuite,

        [Parameter()]
        [string]
        $Environment
    )

    foreach ($Module in (Get-TestSuite -Name $TestSuite)) {
        $TestSuitePath = $Module.ModuleBase

        if (Test-Path -Path $TestSuitePath\data) {
            $TestDataEnvironments = Get-ChildItem -Path $TestSuitePath\data -Directory

            if (-not $TestDataEnvironments) {
                $TestDataEnvironments = Get-Item -Path $TestSuitePath\data
            }
        }

        if (Test-Path -Path $TestSuitePath\helpers) {
            $TestHelperEnvironments = Get-ChildItem -Path $TestSuitePath\helpers -Directory

            if (-not $TestHelperEnvironments) {
                $TestHelperEnvironments = Get-Item -Path $TestSuitePath\helpers
            }
        }

        $TestData = Get-ChildItem -Path $TestSuitePath\tests -Recurse -File

        foreach ($HelperEnv in $TestHelperEnvironments) {
            if ($HelperEnv.Name -eq 'helpers') {
                $Env = 'None'
            }
            else {
                $Env = $HelperEnv.Name
            }

            if ((-not $Environment) -or ($Environment -eq $Env)) {
                $DataEnv = $TestDataEnvironments | Where-Object -Property Name -eq $Env

                if (-not $DataEnv) {
                    $DataEnv = $TestDataEnvironments | Select-Object -First 1
                }

                Get-ChildItem -Path $HelperEnv.FullName -Recurse -Filter '*.ps1' | ForEach-Object {
                    $Name = $_.BaseName
                    $Data = Get-ChildItem -Path $DataEnv.FullName -Recurse -Filter "$Name*" | ForEach-Object {
                        if (-not $_.PSIsContainer) {
                            Import-PowerShellDataFile -Path $_.FullName
                        }
                    }

                    $TestPath = ($TestData | Where-Object -Property Name -like "$Name*").FullName

                    if ($null -eq $TestPath) {
                        $TestPath = ($TestData | Where-Object { $_.Directory.Name -eq $Name }).FullName
                    }

                    $values = @{
                        Name            = $Name
                        DataDirectory   = $DataEnv.FullName
                        HelperDirectory = $_.Directory
                        TestDirectory   = "$TestSuitePath\tests"
                        DataPath        = (Get-ChildItem -Path $DataEnv.FullName -Recurse -Filter "$Name*").FullName
                        TestSuite       = $Module.Name
                        Data            = $Data
                        TestPath        = $TestPath
                        Environment     = 'none'
                        Version         = $Module.Version
                        HelperPath      = $_.FullName
                    }

                    if ($HelperEnv.Name -ne 'helpers') {
                        $values.Environment = $HelperEnv.Name
                    }

                    New-Object -TypeName PSobject -Property $values
                }
            }
        }
    }
}