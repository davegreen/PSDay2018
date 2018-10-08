if ([version]$psversiontable.psversion -gt [version]'4.0') {
    Register-ArgumentCompleter -CommandName Invoke-TestSuite, Get-TestSuiteData -ParameterName TestSuite -ScriptBlock {
        # This is the argument completer to return available timezone
        # parameters for use with getting and setting the timezone.
        Param(
            $commandName, #The command calling this arguement completer.
            $parameterName, #The parameter currently active for the argument completer.
            $currentContent, #The current data in the prompt for the parameter specified above.
            $commandAst, #The full AST for the current command.
            $fakeBoundParameters #A hashtable of the current parameters on the prompt.
        )

        $module = Get-TestSuite
        $module | Where-Object { $_.Name -like "$($currentContent)*" } | ForEach-Object {
            $CompletionText = $_.Name
            if ($_ -match '\s') {
                $CompletionText = "'$($_.Name)'"
            }

            New-Object System.Management.Automation.CompletionResult (
                $CompletionText, #Completion text that will show up on the command line.
                "$($_.Name) ($($_.Path))", #List item text that will show up in intellisense.
                'ParameterValue', #The type of the completion result.
                "$($_.Name) ($($_.Path))"   #The tooltip info that will show up additionally in intellisense.
            )
        }
    }

    Register-ArgumentCompleter -CommandName Invoke-TestSuite -ParameterName Version -ScriptBlock {
        # This is the argument completer to return available timezone
        # parameters for use with getting and setting the timezone.
        Param(
            $commandName, #The command calling this arguement completer.
            $parameterName, #The parameter currently active for the argument completer.
            $currentContent, #The current data in the prompt for the parameter specified above.
            $commandAst, #The full AST for the current command.
            $fakeBoundParameters #A hashtable of the current parameters on the prompt.
        )

        $AvailableVersions = (Get-TestSuite -Name $fakeBoundParameters.TestSuite).Version
        $AvailableVersions | Where-Object { $_.ToString() -like "$($currentContent)*" } | ForEach-Object {
            $CompletionText = $_.ToString()
            if ($_ -match '\s') {
                $CompletionText = "'$($_.ToString())'"
            }

            New-Object System.Management.Automation.CompletionResult (
                $CompletionText, #Completion text that will show up on the command line.
                "$($_.ToString())", #List item text that will show up in intellisense.
                'ParameterValue', #The type of the completion result.
                "$($_.ToString())"   #The tooltip info that will show up additionally in intellisense.
            )
        }
    }

    Register-ArgumentCompleter -CommandName Get-TestSuiteData, Invoke-TestSuite -ParameterName Environment -ScriptBlock {
        # This is the argument completer to return available timezone
        # parameters for use with getting and setting the timezone.
        Param(
            $commandName, #The command calling this arguement completer.
            $parameterName, #The parameter currently active for the argument completer.
            $currentContent, #The current data in the prompt for the parameter specified above.
            $commandAst, #The full AST for the current command.
            $fakeBoundParameters #A hashtable of the current parameters on the prompt.
        )

        $Environments = (Get-TestSuiteData -TestSuite $fakeBoundParameters.TestSuite).Environment | Select-Object -Unique
        $Environments | Where-Object { $_.ToString() -like "$($currentContent)*" } | ForEach-Object {
            $CompletionText = $_.ToString()
            if ($_ -match '\s') {
                $CompletionText = "'$($_.ToString())'"
            }

            New-Object System.Management.Automation.CompletionResult (
                $CompletionText, #Completion text that will show up on the command line.
                "$($_.ToString())", #List item text that will show up in intellisense.
                'ParameterValue', #The type of the completion result.
                "$($_.ToString())"   #The tooltip info that will show up additionally in intellisense.
            )
        }
    }

    $IncludeExclude = {
        # This is the argument completer to return available timezone
        # parameters for use with getting and setting the timezone.
        Param(
            $commandName, #The command calling this arguement completer.
            $parameterName, #The parameter currently active for the argument completer.
            $currentContent, #The current data in the prompt for the parameter specified above.
            $commandAst, #The full AST for the current command.
            $fakeBoundParameters #A hashtable of the current parameters on the prompt.
        )

        $Tests = (Get-TestSuiteData -TestSuite $fakeBoundParameters.TestSuite).Name | Select-Object -Unique
        $Tests | Where-Object { $_.ToString() -like "$($currentContent)*" } | ForEach-Object {
            $CompletionText = $_.ToString()
            if ($_ -match '\s') {
                $CompletionText = "'$($_.ToString())'"
            }

            New-Object System.Management.Automation.CompletionResult (
                $CompletionText, #Completion text that will show up on the command line.
                "$($_.ToString())", #List item text that will show up in intellisense.
                'ParameterValue', #The type of the completion result.
                "$($_.ToString())"   #The tooltip info that will show up additionally in intellisense.
            )
        }
    }

    Register-ArgumentCompleter -CommandName Invoke-TestSuite -ParameterName IncludeTests -ScriptBlock $IncludeExclude
    Register-ArgumentCompleter -CommandName Invoke-TestSuite -ParameterName ExcludeTests -ScriptBlock $IncludeExclude
}