---
layout: default
title: 'GoDaddy API and PowerShell: Part 2'
categories:
- PowerShell
tags:
- PowerShell
- GoDaddy
- API
- Function
---
# Building a Function

Once I was successful in making calls to the API, I wanted to build a function that made future calls much easier and cleaner. I wanted more granular options as well, such as only returning A records or records with a specific name. The full [documentation](https://developer.godaddy.com/doc#!/_v1_domains/recordGet) details the format and acceptable values.[^1]

I always start my functions with a snippet. If you're using PowerShell ISE, `CTRL+J` then select `Cmdlet - (advanced function)`. ![Cmdlet Snippet](../assets/cmdletsnippet.png)

## Parameters

Based on the API docs, I knew I would need three parameters: domain, type, and name. I also knew that the value of type was restricted to either A, AAAA, CNAME, MX, NS, SOA, SRV, or TXT. I used the parameter attribute [ValidateSet](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_functions_advanced_parameters#validateset-attribute) to limit the possible input to only those options. ValidateSet is also used by intellisense for tab completion.

I also knew that if I wanted to use the Name parameter that I would have to use the Type parameter as well. I used the [ParameterSetName](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_functions_advanced_parameters#parametersetname-argument) argument to accomplish this.

This is what my parameter block looked like:

~~~ powershell
Param
(
    [Parameter(ParameterSetName='Default',
               Mandatory=$true,
               Position=0)]
    [Parameter(ParameterSetName='Optional',
               Mandatory=$true,
               Position=0)]
    [string]$Domain,

    [Parameter(ParameterSetName='Optional',
               Mandatory=$true,
               Position=1)]
    [ValidateSet('A', 'AAAA', 'CNAME', 'MX', 'NS', 'SOA', 'SRV', 'TXT')]
    [string]$Type,

    [Parameter(ParameterSetName='Optional')]
    [string]$Name
)
~~~





[^1] The documentation states **Retrieve DNS Records for the specified Domain, optionally with the specified Type *and/or* Name**, however I've never been able to figure out how to return all records with a specific name regardless of type.
