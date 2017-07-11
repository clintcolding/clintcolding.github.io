---
layout: post
title: 'Quick Tip: Navigate a Datastore'
categories:
- PowerShell
tags:
- PowerShell
- PowerCLI
- VMware
---
This is a quick and easy trick for managing files on a VMware datastore. It comes in handy quite a bit, I've even wrapped it in simple a [function](https://github.com/clintcolding/TheToolbox/blob/master/Map-Datastore.ps1).

~~~ powershell
$DS = Get-Datastore MyDatastore

New-PSDrive -Location $DS -Name ds -PSProvider VimDatastore -root "\"

Set-Location ds:\
~~~

After that you can `dir`, `Copy-DatastoreItem`, `Remove-Item`, etc. Basically any command you can run against a file system, you can run against a datastore.
