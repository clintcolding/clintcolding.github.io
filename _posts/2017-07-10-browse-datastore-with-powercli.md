---
layout: post
title: 'Manage a Datastore with PowerCLI'
categories:
- PowerShell
tags:
- PowerShell
- PowerCLI
- VMware
---
This is a quick and easy trick for managing files on a VMware datastore with PowerCLI. It comes in handy quite a bit, I've even wrapped it in simple a [function](https://github.com/clintcolding/TheToolbox/blob/master/Map-Datastore.ps1).

~~~ powershell
$DS = Get-Datastore MyDatastore

New-PSDrive -Location $DS -Name ds -PSProvider VimDatastore -root "\"
~~~

After that you can `cd ds:\` and `dir`, `Copy-DatastoreItem`, `Remove-Item`, etc. Basically any command you can run against a file system, you can run against a datastore.
