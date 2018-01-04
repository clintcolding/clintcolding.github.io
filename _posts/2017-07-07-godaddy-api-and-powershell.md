---
layout: post
title: 'Getting Started with API’s in PowerShell'
categories:
- PowerShell
tags:
- PowerShell
- GoDaddy
- API
---

PowerShell is an impressively powerful tool and one of its most powerful features is its ability to call API’s. For those of us that have a primarily infrastructure focused background, we understand what an API is and does, but we’re a little foggy on how to use them.

The first API project I completed used the GoDaddy API. I was frustrated with the tedious process of using the GoDaddy web portal to update DNS records across our various domains. So I decided to create more efficient PowerShell commands.

I started off doing some research, thankfully GoDaddy has wonderful [documentation](https://developer.godaddy.com/) of their API’s. I decided a logical place to start was to return all the records associated with a specific domain. Under the /v1/domains API, I found a Get request that retrieves DNS records for the specified domain:

![GoDaddy Get API](/images/godaddyget.png)

The first step of making any API call is finding the API URL and what type of authentication is needed, if any. By expanding the documentation pane above, I found both.

The URL was `https://api.godaddy.com/v1/domains/mydomain.com/records` and the authentication was in the request header:

![GoDaddy API Header](/images/godaddyheaders.png)

Now that I knew what I needed, I could start building my PowerShell script. To make the API call I used `Invoke-WebRequest` with the following parameters:

- URI: Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent.
- Method: Specifies the method used for the web request. (Get, Post, Put, etc)
- Headers: Specifies the headers of the web request. Enter a hash table or dictionary.

First I needed to create a “Authorization” table with my key/secret pair that I could pass into the request header. You can get your API keys [here](https://developer.godaddy.com/keys/). (Use a production key.)

```
$apiKey = '2s7Yn1f2dW_W5KJhWbGwuLhyW4Xdvgb2c'
$apiSecret = 'oMmm2m5TwZxrYyXwXZnoN'

$Headers = @{}
$Headers["Authorization"] = 'sso-key ' + $apiKey + ':' + $apiSecret
```

*Remember, we need to recreate the request header that we found in the documentation.*

Once I was confident that I’d be able to authenticate, I ran `Invoke-WebRequest` using the `Get` method to retrieve all records for my domain. The API successfully returned the data in JSON:

```
C:\> Invoke-WebRequest https://api.godaddy.com/v1/domains/clintcolding.com/records/ -Method Get -Headers $Headers

StatusCode        : 200
StatusDescription : OK
Content           : [{"type":"A","name":"@","data":"192.30.252.153","ttl":600},{"type":"A","name":"@","data":"19
                    2.30.252.154","ttl":600},{"type":"CNAME","name":"email","data":"email.secureserver.net","ttl
                    ":3600},{"type":...
RawContent        : HTTP/1.1 200 OK
                    Access-Control-Allow-Credentials: true
                    Vary: Origin,Accept-Encoding
                    x-newrelic-app-data: PxQPUVdRCwcTVlRXDgkOVVATGhE1AwE2QgNWEVlbQFtcCxYkSRFBBxdFXRJJJH1nH0sXUxh
                    VWAsFWFhATVwHDV0DUQwX...
Forms             : {}
Headers           : {[Access-Control-Allow-Credentials, true], [Vary, Origin,Accept-Encoding],
                    [x-newrelic-app-data, PxQPUVdRCwcTVlRXDgkOVVATGhE1AwE2QgNWEVlbQFtcCxYkSRFBBxdFXRJJJH1nH0sXUx
                    hVWAsFWFhATVwHDV0DUQwXSlFRXBddEh5bRxsUUwhOXA1ZXlVbQ04HHQdIVQAGC1ReW1cFWwFbAQENCwpJG1cIVxFORg
                    5UVQRbDAIAXQRVBgMPREhXV18RAz4=], [Access-Control-Allow-Origin, *]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 696
```

To get a more legible output, I reran the command. This time, piping the output to `ConvertFrom-Json`.

```
C:\> Invoke-WebRequest https://api.godaddy.com/v1/domains/clintcolding.com/records/ -Method Get -Headers $Headers | ConvertFrom-Json

type  name           data                                 ttl
----  ----           ----                                 ---
A     @              192.30.252.153                       600
A     @              192.30.252.154                       600
CNAME email          email.secureserver.net              3600
CNAME ftp            @                                   3600
CNAME www            @                                   3600
CNAME _domainconnect _domainconnect.gd.domaincontrol.com 3600
MX    @              mailstore1.secureserver.net         3600
MX    @              smtp.secureserver.net               3600
NS    @              ns53.domaincontrol.com              3600
NS    @              ns54.domaincontrol.com              3600
```

After successfully retrieving the DNS records for my domain, I repeated the process, this time using the `Put` method.

In the end, this made updating DNS entries across our domains much more efficient. I also built custom DNS failover scripts for disaster recovery.

I have a [GitHub project](https://github.com/clintcolding/GoDaddy) that includes the basic Get, Add, and Set commands for working with your GoDaddy DNS.

This is just a glimpse of what you can do with GoDaddy’s API. Make sure to check out the [documentation](https://developer.godaddy.com/doc), I’d love to see what you automate!