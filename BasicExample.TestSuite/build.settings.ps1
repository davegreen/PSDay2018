###############################################################################
# Customize these properties and tasks for your module.
###############################################################################

Properties {
    # ----------------------- Basic properties --------------------------------

    # The root directories for the module's docs, src and test.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DocsRootDir = "$PSScriptRoot\docs"
    $SrcRootDir = "$PSScriptRoot\src"
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestRootDir = "$PSScriptRoot\test"

    # The name of your module should match the basename of the PSD1 file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleName = (Get-Item -Path $PSScriptRoot).Name

    # The $OutDir is where module files and updatable help files are staged for signing, install and publishing.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $OutDir = "$PSScriptRoot\Release"

    # The $ModuleRoot is the module psm1 to load for understanding the available commands.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleRoot = "$SrcRootDir\$ModuleName.psm1"

    # The $ManifestData is the file path to the manifest data containing the non-generated data.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ManifestData = "$PSScriptRoot\Manifest.Data.psd1"

    # Import the module to get all of the available commands.
    # Removes all versions of the module from the session before importing.
    Get-Module $ModuleName | Remove-Module -Force
    $Module = Import-Module $ModuleRoot -PassThru -ErrorAction Stop
    $ModuleCommands = Get-Command -Module $Module
    Remove-Module $Module -Force

    # Add the module commands into the three categories for the manifest.
    if ($ModuleCommands) {
        $Function = $ModuleCommands | Where-Object { $_.CommandType -eq 'Function' -and $_.Name -like '*-*' }
        $Cmdlet = $ModuleCommands | Where-Object { $_.CommandType -eq 'Cmdlet' -and $_.Name -like '*-*' }
        $Alias = $ModuleCommands | Where-Object { $_.CommandType -eq 'Alias' -and $_.Name -like '*-*' }
    }

    # Build the FileList for the manifest.
    Push-Location -Path $SrcRootDir
    $FileList = (Get-ChildItem -Recurse | Resolve-Path -Relative).Substring(2) | Where-Object { $_ -like '*.*' }
    Pop-Location

    $ModuleDescription = Import-PowerShellDataFile -Path $ManifestData
    $ModuleDescription.Add('Path', "$(Split-Path -Path $ModuleRoot)\$((Get-Item -Path $ModuleRoot).BaseName).psd1")
    $ModuleDescription.Add('RootModule', "$ModuleName.psm1")
    $ModuleDescription.Add('FileList', $FileList)
    $ModuleDescription.Add('FunctionsToExport', $Function)
    $ModuleDescription.Add('CmdletsToExport', $Cmdlet)
    $ModuleDescription.Add('AliasesToExport', $Alias)
    $ModuleDescription.Add('ReleaseNotes', (Get-Content -Path "$PSScriptRoot\CHANGELOG.md" -Raw))

    [string]$Tags = $ModuleDescription.Tags | ForEach-Object { "'$_' " }

    [xml]$ModuleNuspec = @"
<?xml version="1.0"?>
<package >
  <metadata>
    <id>$ModuleName</id>
    <version>$($ModuleDescription.ModuleVersion)</version>
    <authors>$($ModuleDescription.Author)</authors>
    <owners>$($ModuleDescription.Author)</owners>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>$($ModuleDescription.Description)</description>
    <releaseNotes>$(Get-Content -Path "$PSScriptRoot\CHANGELOG.md" -Raw)</releaseNotes>
    <copyright>$($ModuleDescription.Copyright)</copyright>
    <tags>$Tags</tags>
  </metadata>
</package>
"@

    # The local installation directory for the install task. Defaults to your home Modules location.
    # The test for $profile is for the Plaster AppVeyor build machine since it doesn't define $profile.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $InstallPath = Join-Path (Split-Path $(if ($profile) {$profile} else {$Home}) -Parent) `
        "Modules\$ModuleName\$($ModuleDescription.ModuleVersion)"

    # Default Locale used for help generation, defaults to en-US.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DefaultLocale = 'en-US'

    # Items in the $Exclude array will not be copied to the $OutDir e.g. $Exclude = @('.gitattributes')
    # Typically you wouldn't put any file under the src dir unless the file was going to ship with
    # the module. However, if there are such files, add their $SrcRootDir relative paths to the exclude list.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $Exclude = @()

    # ------------------ Script analysis properties ---------------------------

    # Enable/disable use of PSScriptAnalyzer to perform script analysis.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptAnalysisEnabled = $true

    # When PSScriptAnalyzer is enabled, control which severity level will generate a build failure.
    # Valid values are Error, Warning, Information and None.  "None" will report errors but will not
    # cause a build failure.  "Error" will fail the build only on diagnostic records that are of
    # severity error.  "Warning" will fail the build on Warning and Error diagnostic records.
    # "Any" will fail the build on any diagnostic record, regardless of severity.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Error'

    # Path to the PSScriptAnalyzer settings file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\scriptanalyzer.settings.psd1"

    # ------------------- Script signing properties ---------------------------

    # Set to $true if you want to sign your scripts. You will need to have a code-signing certificate.
    # You can specify the certificate's subject name below. If not specified, you will be prompted to
    # provide either a subject name or path to a PFX file.  After this one time prompt, the value will
    # saved for future use and you will no longer be prompted.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptSigningEnabled = $false

    # Specify the Subject Name of the certificate used to sign your scripts.  Leave it as $null and the
    # first time you build, you will be prompted to enter your code-signing certificate's Subject Name.
    # This variable is used only if $SignScripts is set to $true.
    #
    # This does require the code-signing certificate to be installed to your certificate store.  If you
    # have a code-signing certificate in a PFX file, install the certificate to your certificate store
    # with the command below. You may be prompted for the certificate's password.
    #
    # Import-PfxCertificate -FilePath .\myCodeSigingCert.pfx -CertStoreLocation Cert:\CurrentUser\My
    #
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CertSubjectName = $null

    # Certificate store path.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CertPath = "Cert:\"

    # -------------------- File catalog properties ----------------------------

    # Enable/disable generation of a catalog (.cat) file for the module.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CatalogGenerationEnabled = $true

    # Select the hash version to use for the catalog file: 1 for SHA1 (compat with Windows 7 and
    # Windows Server 2008 R2), 2 for SHA2 to support only newer Windows versions.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CatalogVersion = 2

    # ---------------------- Testing properties -------------------------------

    # Enable/disable Pester code coverage reporting.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CodeCoverageEnabled = $true

    # CodeCoverageFiles specifies the files to perform code coverage analysis on. This property
    # acts as a direct input to the Pester -CodeCoverage parameter, so will support constructions
    # like the ones found here: https://github.com/pester/Pester/wiki/Code-Coverage.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CodeCoverageFiles = "$SrcRootDir\*.ps1", "$SrcRootDir\*.psm1"

    # -------------------- Publishing properties ------------------------------

    # Your NuGet API key for the PSGallery.  Leave it as $null and the first time you publish,
    # you will be prompted to enter your API key.  The build will store the key encrypted in the
    # settings file, so that on subsequent publishes you will no longer be prompted for the API key.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $NuGetApiKey = $null

    # Name of the repository you wish to publish to. If $null is specified the default repo (PowerShellGallery) is used.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $PublishRepository = $null

    # Path to the release notes file.  Set to $null if the release notes reside in the manifest file.
    # The contents of this file are used during publishing for the ReleaseNotes parameter.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ReleaseNotesPath = "$PSScriptRoot\ReleaseNotes.md"

    # ----------------------- Misc properties ---------------------------------

    # In addition, PFX certificates are supported in an interactive scenario only,
    # as a way to import a certificate into the user personal store for later use.
    # This can be provided using the CertPfxPath parameter. PFX passwords will not be stored.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $SettingsPath = "$env:LOCALAPPDATA\Plaster\NewModuleTemplate\SecuredBuildSettings.clixml"

    # Specifies an output file path to send to Invoke-Pester's -OutputFile parameter.
    # This is typically used to write out test results so that they can be sent to a CI
    # system like AppVeyor.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestOutputFile = $null

    # Specifies the test output format to use when the TestOutputFile property is given
    # a path.  This parameter is passed through to Invoke-Pester's -OutputFormat parameter.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestOutputFormat = "NUnitXml"

    # Specifies which prerequisites are installed.
    # Pass in @{ InstallPrerequisites = $true; prereqCredential = 'username', 'password' }
    # as a psake parameter to install prerequisites.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $Prerequisites = 'Pester', 'psake', 'AzureAD', 'MSOnline'
}

###############################################################################
# Customize these tasks for performing operations before and/or after file staging.
###############################################################################

# Executes before the StageFiles task.
Task BeforeStageFiles -depends BuildManifests {
}

# Executes after the StageFiles task.
Task AfterStageFiles {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Build.
###############################################################################

# Executes before the BeforeStageFiles phase of the Build task.
Task BeforeBuild {
}

# Executes after the Build task.
Task AfterBuild {
}

###############################################################################
# Customize these tasks for performing operations before and/or after BuildHelp.
###############################################################################

# Executes before the BuildHelp task.
Task BeforeBuildHelp {
}

# Executes after the BuildHelp task.
Task AfterBuildHelp {
}

###############################################################################
# Customize these tasks for performing operations before and/or after BuildUpdatableHelp.
###############################################################################

# Executes before the BuildUpdatableHelp task.
Task BeforeBuildUpdatableHelp {
}

# Executes after the BuildUpdatableHelp task.
Task AfterBuildUpdatableHelp {
}

###############################################################################
# Customize these tasks for performing operations before and/or after GenerateFileCatalog.
###############################################################################

# Executes before the GenerateFileCatalog task.
Task BeforeGenerateFileCatalog {
}

# Executes after the GenerateFileCatalog task.
Task AfterGenerateFileCatalog {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Install.
###############################################################################

# Executes before the Install task.
Task BeforeInstall {
}

# Executes after the Install task.
Task AfterInstall {
}

###############################################################################
# Customize these tasks for performing operations before and/or after Publish.
###############################################################################

# Executes before the Publish task.
Task BeforePublish {
}

# Executes after the Publish task.
Task AfterPublish {
}

Task BuildManifests {
    New-ModuleManifest @ModuleDescription
    $ModuleNuspec.Save("$(Split-Path -Path $ModuleRoot)\$((Get-Item -Path $ModuleRoot).BaseName).nuspec")
}