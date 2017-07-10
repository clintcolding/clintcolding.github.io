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

Once I was successful in making calls to the API, I wanted to build a function that made future calls much easier and cleaner. I wanted more granular options as well, such as only returning A records or records with a specific name. The full [documentation](https://developer.godaddy.com/doc#!/_v1_domains/recordGet) details the format and acceptable values[^1].

> I always start my functions with a snippet. If you're using PowerShell ISE, `CTRL+J` then select `Cmdlet - (advanced function)`.

## Parameters

Based on the API docs, I knew I would need three parameters: domain, type, and name. I also knew that the value of type was restricted to either A, AAAA, CNAME, MX, NS, SOA, SRV, or TXT. I used the parameter attribute  [ValidateSet](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_functions_advanced_parameters#validateset-attribute) to limit the possible input to only those options. ValidateSet is also used by intellisense for tab completion.

If you try to make a call with just the Domain and Name parameters, the call will fail. You must also specify the Type parameter. To make this mandatory, I used the [ParameterSetName](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_functions_advanced_parameters#parametersetname-argument) argument. This gives you three valid parameter combinations:

1. Domain
2. Domain + Type
3. Domain + Type + Name

~~~ powershell
[CmdletBinding(DefaultParameterSetName='Default')]

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

If you're unfamiliar with the method blocks of an advanced function I would encourage you to read [this](https://technet.microsoft.com/en-us/library/hh413265.aspx).

## Begin

In [Part 1](.\_posts\2017-07-07-godaddy-api-and-powershell-part-1.md) we created our authentication headers. Since this only needs to be created and set once, I like to add it in the begin block.

~~~ powershell
Begin{
  $apiKey = '2s7Yn1f2dW_W5KJhWbGwuLhyW4Xdvgb2c'
  $apiSecret = 'oMmm2m5TwZxrYyXwXZnoN'

  $Headers = @{}
  $Headers["Authorization"] = 'sso-key ' + $apiKey + ':' + $apiSecret
}
~~~

## Process

In [Part 1](.\_posts\2017-07-07-godaddy-api-and-powershell-part-1.md) we made a call that returned all records for a given domain. By replacing our hardcoded domain with our variable parameter, and adding our new parameters, we have this:

~~~ powershell
Process{
  Invoke-WebRequest https://api.godaddy.com/v1/domains/$Domain/records/$Type/$Name -Method Get -Headers $Headers | ConvertFrom-Json
}
~~~

### Footnotes

[^1]: The documentation states "Retrieve DNS Records for the specified Domain, optionally with the specified Type **and/or** Name", however I've never been able to figure out how to return all records with a specific name regardless of type.
