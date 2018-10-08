---
external help file: Test-Business-help.xml
online version: 
schema: 2.0.0
---

# Get-TestSuite

## SYNOPSIS
Return available testsuite modules available on the system.
If a path is specified,
this path is also searched and any available testsuite modules imported.

## SYNTAX

### Name (Default)
```
Get-TestSuite [-Name <String[]>] [-ListAvailable] [-All] [<CommonParameters>]
```

### Path
```
Get-TestSuite -Path <FileInfo[]> [-ListAvailable] [-All] [<CommonParameters>]
```

## DESCRIPTION
Return available testsuite modules available on the system.
If a path is specified,
this path is also searched and any available testsuite modules imported.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-TestSuite
```

Outputs module data about test suite modules that have been discovered using names (for module directories),
or though paths to a module *.psm1* or *.psd1*.

## PARAMETERS

### -Name
Only return names like the one typed.
Results are returned with the name Name*.TestSuite.

```yaml
Type: String[]
Parameter Sets: Name
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path to search for a testsuite module.

```yaml
Type: FileInfo[]
Parameter Sets: Path
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListAvailable
Check from all available modules, instead of modules loaded into the current session.

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

### -All
Return all versions, not just the latest one found for a particular module.

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

