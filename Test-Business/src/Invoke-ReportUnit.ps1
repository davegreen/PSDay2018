function Invoke-ReportUnit {
    <#
        .Synopsis
        Starts ReportUnit and processes folders of test results to convert into HTML format.

        .Description
        Starts ReportUnit and processes folders of test results to convert into HTML format.
        This downloads (if required) and runs reportunit on the specified files.

        .Parameter Path
        Path refers to the path of the NUnit test output.

        .Parameter OutputPath
        OutputPath refers to the location to output the HTML files.

        .Parameter OpenHTML
        Attempts to open Index.html after processing a folder.

        .Example
        Invoke-ReportUnit -Path .\path\to\nunit\test\output

        Raw output from ReportUnit containing info about the XML files being processed.
        This downloads (if required) and runs reportunit on the specified files.

        .Notes
        Author: David Green
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo[]]
        $Path,

        [Parameter()]
        [System.IO.FileInfo]
        $OutputPath,

        [Parameter()]
        [switch]
        $OpenHTML
    )

    $Path = (Resolve-Path -Path $Path).Path
    $RUPath = "$($env:TEMP)\reportunit.exe"
    $Version = '1.5.0.0'

    # Download and extract ReportUnit.exe if needed
    if (-not ((Test-Path -Path $RUPath) -and ((Get-Item -Path $RUPath).VersionInfo.FileVersion -eq $Version))) {
        # $url = 'http://relevantcodes.com/Tools/ReportUnit/reportunit-1.2.zip'
        $url = 'http://relevantcodes.com/Tools/ReportUnit/reportunit-1.5-beta1.zip'
        $RUPath = Join-Path $env:TEMP $url.Split("/")[-1]
        Write-Verbose -Message "Downloading ReportUnit from $url to $RUPath"
        (New-Object Net.WebClient).DownloadFile($url, $RUPath)
        Write-Verbose -Message "Extracting ReportUnit"
        Expand-Archive -Path $RUPath -DestinationPath $env:TEMP -Force
    }

    Write-Verbose -Message "Running ReportUnit on $Path"
    if ($OutputPath) {
        $OutputPath = (Resolve-Path -Path $OutputPath).Path
        & $env:TEMP\reportunit.exe $Path $OutputPath

        if ($OpenHTML) {
            Invoke-Item -Path "$OutputPath\Index.html"
        }
    }
    else {
        & $env:TEMP\reportunit.exe $Path

        if ($OpenHTML) {
            Invoke-Item -Path "$Path\Index.html"
        }
    }
}