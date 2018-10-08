---
external help file: Test-Business-help.xml
online version: 
schema: 2.0.0
---

# Invoke-ReportUnit

## SYNOPSIS
Starts ReportUnit and processes folders of test results to convert into HTML format.

## SYNTAX

```
Invoke-ReportUnit [-Path] <FileInfo[]> [[-OutputPath] <FileInfo>] [-OpenHTML] [<CommonParameters>]
```

## DESCRIPTION
Starts ReportUnit and processes folders of test results to convert into HTML format.
This downloads (if required) and runs reportunit on the specified files.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-ReportUnit -Path .\path\to\nunit\test\output
```

Raw output from ReportUnit containing info about the XML files being processed.
This downloads (if required) and runs reportunit on the specified files.

## PARAMETERS

### -Path
Path refers to the path of the NUnit test output.

```yaml
Type: FileInfo[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
OutputPath refers to the location to output the HTML files.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenHTML
Attempts to open Index.html after processing a folder.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: David Green

## RELATED LINKS

