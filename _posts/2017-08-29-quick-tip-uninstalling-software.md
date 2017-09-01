---
layout: post
title: 'Quick Tip: Uninstalling Software'
categories:
- Quick Tip
tags:
- PowerShell
excerpt: This is a quick tip for uninstalling software with PowerShell.
image: /images/thumbnails/posh.png
---
> This is a quick tip to using the Win32_Product class to uninstall applications.

To start, you'll need to find the application you want to remove. `Get-WmiObject -Class win32_product` will return all installed applications on the machine. 

We can then filter out what we're looking for using `Where-Object`.

And then call the uninstall method for Win32_Product class to uninstall the product:

``` powershell
(Get-WmiObject -Class win32_product | where {$_.Name -like "*Foxit*"}).uninstall()
```