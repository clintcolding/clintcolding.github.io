---
layout: post
title: 'Deploying an OVF with PowerCLI'
categories:
- VMware
tags:
- PowerCLI
excerpt: A quick walk through of deploying an OVF template with PowerCLI.
image: /images/thumbnails/vmware.png
---

To install an OVF template with PowerCLI you can use `Import-VApp`. But before we do, we need to update our OVF configuration for deployment.

First, we start by creating a variable containing our OVF path:
``` powershell
$ovfpath = "C:\bin\LoadMaster-VLM-7.2.39.1.15589.RELEASE-VMware-VBox-OVF-FREE.ovf"
```

Using `Get-OvfConfiguration` we view configurable properties:
``` powershell
$ovfconfig = Get-OvfConfiguration -Ovf $ovfpath
$ovfconfig.ToHashTable() | ft
```

Mine only had two properties:
``` console
Name                   Value
----                   -----
NetworkMapping.Farm
NetworkMapping.Network
```

To set the values I ran:
``` powershell
$ovfconfig.NetworkMapping.Farm.Value = "DMZ"
$ovfconfig.NetworkMapping.Network.Value = "VM Network"
```

Before running `Import-VApp` I captured my host and datastore in variables:
``` powershell
$vmhost = get-vmhost labhost1.a1.local
$ds = Get-Datastore datastore1
```

And finally, using `Import-VApp`, deployed the OVF template:
``` powershell
Import-VApp -Source $ovfpath -OvfConfiguration $ovfconfig -Name A1-LB-01 -VMHost $vmhost -Datastore $ds -DiskStorageFormat Thin
```