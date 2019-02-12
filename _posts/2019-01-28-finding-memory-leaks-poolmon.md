---
layout: post
title: 'Finding Memory Leaks with PoolMon'
categories:
- Windows
tags:
- PoolMon
---

1. Download the [Windows Driver Kit](https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk) from Microsoft.

> You only need the WDK, disregard the Visual Studio downloads.

2. Install the WDK on your workstation.

> You can install the WDK anywhere, once installed we'll grab the actual PoolMon file.

3. Navigate to `C:\Program Files (x86)\Windows Kits\10\Tools\x64` and copy `poolmon.exe` to the target machine.

4. Now run the following command to start PoolMon and sort by number of bytes:

`poolmon /b`

![PoolMon](/static/img/_posts/poolmon.PNG)

> Usually the best way to determine if a driver is leaking memory is if its allocating memory faster than its freeing.

5. Once you've found a suspect process, note the Tag assigned to it, in my case its MFeS.

6. Next run the following to determine which driver the tag is associated with:

``` powershell
Set-Location "C:\Windows\System32\drivers"
Select-String -Path *.sys -Pattern "MFeS" -CaseSensitive | Select-Object FileName -Unique
```

For me, the MFeS tag was associated with mfeavfk.sys, which turned out to be a McAfee driver.