---
external help file: Test-Business-help.xml
online version: 
schema: 2.0.0
---

# Write-TestSummary

## SYNOPSIS
Gets test data from a set of test results and outputs summary information for the results.

## SYNTAX

```
Write-TestSummary [-Path] <FileInfo[]>
```

## DESCRIPTION
Gets test data from a set of test results and outputs summary information for the results.
To summarise tests, pass it a folder containing XML files, or an XML file directly and the test summary will be generated.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Write-TestSummary -Path .\path\to\output
```

Writes a test summary to standard output.

## PARAMETERS

### -Path
The folder containing test results to get test summary data for.

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

## INPUTS

## OUTPUTS

## NOTES
Author: David Green

## RELATED LINKS

