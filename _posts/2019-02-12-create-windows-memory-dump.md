---
layout: post
title: 'Generate a Windows Memory Dump from VMware'
categories:
- VMware
tags:
- Windows
---

1. Download the [Vmss2core](https://labs.vmware.com/flings/vmss2core) tool from VMware Flings.
2. Suspend the VM you want to collect the memory dump for, this will generate a `.vmss` file.
3. Navigate to the datastore your VM resides on and download the `.vmss` and `.vmem` files.
4. Move the VM and the Vmss2core files into the same folder.
5. Run the following command to generate a `.dmp` file:

```
.\vmss2core-sb-8456865.exe -W8 TESTVM-4409dd21.vmss TESTVM-4409dd21.vmem
```

6. Once complete you will have a `memory.dmp` file that you can further analyze.