---
layout: post
title: 'Finding Memory Leaks with PoolMon'
categories:
- Windows
tags:
- PoolMon
comments: true
---

While troubleshooting high memory use, I came across the situation where Windows Resource Monitor wasn't reporting hardly any memory use at all, yet there was only about 10% free. I used the process outlined below to find kernel memory leak.

Download the [Windows Driver Kit](https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk) from Microsoft.

> You only need the WDK, disregard the Visual Studio downloads.

Install the WDK on your workstation.

> You can install the WDK anywhere, once installed we'll grab the actual PoolMon file.

Navigate to `C:\Program Files (x86)\Windows Kits\10\Tools\x64` and copy `poolmon.exe` to the target machine.

Now run `poolmon /b` to start PoolMon and sort by number of bytes.

![PoolMon](/images/poolmon.PNG)

> Usually the best way to determine if a driver is leaking memory is if its allocating memory faster than its freeing.

Once you've found a suspect process, note the Tag assigned to it, in my case its MFeS.

Next run the following to determine which driver the tag is associated with:

``` powershell
Set-Location "C:\Windows\System32\drivers"
Select-String -Path *.sys -Pattern "MFeS" -CaseSensitive | Select-Object FileName -Unique
```

The MFeS tag was associated with mfeavfk.sys, which turned out to be a McAfee driver from the Endpoint Security Platform component.