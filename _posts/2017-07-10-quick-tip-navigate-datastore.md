---
layout: post
title: 'Quick Tip: Navigate a Datastore'
categories:
- Quick Tip
tags:
- PowerShell
- PowerCLI
- VMware
excerpt: This is a quick tip for managing files on a VMware datastore.
---
This is a quick tip for managing files on a VMware datastore. We're simply mapping a datastore to a PSDrive that we can then `cd` to.

~~~ powershell
$DS = Get-Datastore MyDatastore

New-PSDrive -Location $DS -Name ds -PSProvider VimDatastore -root "\"

Set-Location ds:\
~~~

After that, you can `dir`, `Copy-DatastoreItem`, `Remove-Item`, etc. Basically any command you can run against a file system, you can run against a datastore.

It comes in handy quite a bit, I've even wrapped it in a [function](https://github.com/clintcolding/TheToolbox/blob/master/Map-Datastore.ps1).
