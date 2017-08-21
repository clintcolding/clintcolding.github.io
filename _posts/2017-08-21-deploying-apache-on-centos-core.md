---
layout: post
title: 'Deploying Apache on CentOS Core'
categories:
- CentOS
tags:
- CentOS
- Apache
- VMware
excerpt: A quick guide to configuring Apache on CentOS 7 Core.
---

Since I've been working a lot with [Jekyll](https://jekyllrb.com/) and static sites, I figured it was time I actually hosted one on my own. I recently built a wiki site for my company's IT documentation and decided I needed to host it somewhere. We're mainly a Microsoft shop, so to try something new, I deployed it with Apache on CentOS 7 Core.

# Installing CentOS

This should be straightforward, you can download CentOS 7 Minimal [here](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1611.iso).

I installed CentOS on VMware. To install VMware Tools you'll need to run:

``` console
yum install open-vm-tools
```

# Configure Network

Next, you'll need to configure your network. To view all devices run `nmcli d`, which should return something like this:

``` console
DEVICE  TYPE      STATE      CONNECTION
ens192  ethernet  connected  Wired connection 1
lo      loopback  unmanaged  --
```

> Confirm your device is listed. If not you probably need to install drivers as I did with VMware Tools.

To configure your adaptor, run `nmtui`:

![nmtui](/images/nmtui.png)

Continue to *Edit a connection*:

![nmtui](/images/nmtuieditconnection.png)

Select your connection and then configure your settings as needed. I configured a static IP:

![nmtui](/images/nmtuisettings.png)

Finally, back on the main NetworkManager screen, select *Activate a connection*. On the next screen *Deactivate* and then *Activate* your connection. You could also run `service network restart`.

To confirm your settings run `ip a`.

# Install Apache

First make sure your CentOS install is up to date with:

`sudo yum -y update`

And then install Apache with:

`sudo yum -y install httpd`

# Configure Apache

First, we need to allow port 80 through the firewall:

`sudo firewall-cmd --permanent --add-port=80/tcp`

`sudo firewall-cmd --reload`

Next, we'll configure Apache to start on boot:

`sudo systemctl start httpd`

`sudo systemctl enable httpd`

And confirm the status with:

`sudo systemctl status httpd`

You should now be able to browse to your server IP and view the default Apache website, confirming your configuration.

# Upload Website Files

Finally, we're ready to upload our website files. I used [WinSCP](https://winscp.net/eng/download.php) to copy my files to `/var/www/html`.

And that's it! Your site should now be hosted on your new Apache server!