---
layout: post
title: 'Splatting for Readability'
categories:
- PowerShell
tags:
- Splatting
excerpt: Splatting was introduced way back in PowerShell v2 and gave us a new way of passing parameters to our commands.
---

Splatting was introduced way back in PowerShell v2 and gave us a new way of passing parameters to our commands. I've found splatting to be the most helpful in scripts, where maximum readability is crucial. For example, before I learned about splatting, I had a command like this:

~~~ powershell
New-ADUser -Name $Displayname -DisplayName $Displayname -GivenName $FirstName -Surname $LastName -SamAccountName $Username -UserPrincipalName "$Username@mycompany.com" -AccountPassword $SecurePassword -Description $Title -Title $Title -Department $Department -Manager $Manager -Company "My Company" -HomeDrive "H:" -HomeDirectory "\\server\$Username" -Enabled $true
~~~

I passed 15 parameters to `New-ADUser`, and because it's a production script, I named each parameter without truncating.

To increase readability via splatting, we first organize our parameter and value pairs into a [hashtable](https://technet.microsoft.com/en-us/library/ee692803.aspx?f=255&MSPPError=-2147217396) assigned to a variable:

~~~ powershell
    $userparams = @{
        Name              = $Displayname;
        DisplayName       = $Displayname;
        GivenName         = $FirstName;
        Surname           = $LastName;
        SamAccountName    = $Username;
        UserPrincipalName = "$Username@mycompany.com";
        AccountPassword   = $SecurePassword;
        Description       = $Title;
        Title             = $Title;
        Department        = $Department;
        Manager           = $Manager;
        Company           = "My Company";
        HomeDrive         = "H:";
        HomeDirectory     = "\\server\$Username";
        Enabled           = $true
    }
~~~

Now we pass our parameters using `@` followed by our hashtable parameter. Like so:

~~~ powershell
New-ADUser @userparams
~~~

By splatting our parameters we can now easily view them all neatly at once. If we ever need to make changes we don't have to scroll for days and hope we stay on the right line. Future readers of our code will thank us too.

> To splat a switch, pass the value as $true.
> ~~~ powershell
> "UseDefaultCredential" = $true;
> ~~~