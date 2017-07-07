---
layout: post
title: Managing GoDaddy DNS with PowerShell
categories:
- blog
---

# Managing GoDaddy DNS with PowerShell

Like most admins, I work with our public DNS records quite a bit. The most painful part of the process was working through the GoDaddy web portal just to update the same records on a handful of domains. I created a PowerShell module that calls the GoDaddy API to make these simple changes much less frustrating.

I started off doing some research, GoDaddy has wonderful [documentation](https://developer.godaddy.com/). You'll need a key/secret pair to make calls to the API, which you can generate [here](https://developer.godaddy.com/keys/). (Use a production key.)

To make an API call with PowerShell I used `Invoke-WebRequest` with the following parameters:

-URI: Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent. Enter a URI. This parameter supports HTTP, HTTPS, FTP, and FILE values.
-Method: Specifies the method used for the web request. (Get, Post, Put, etc)
-Headers: Specifies the headers of the web request. Enter a hash table or dictionary.

To authenticate the API I had to insert the key/secret into the headers using a [hashtable](https://technet.microsoft.com/en-us/library/ee692803.aspx):

~~~ powershell
$apiKey = 'dKDJceh2SSXk_oMj9SSzzmsZ1AZjmEuQHi'
$apiSecret = 'oMmm2m5TwZxrYyXwXZnoN'

$Headers = @{}
$Headers["Authorization"] = 'sso-key ' + $apiKey + ':' + $apiSecret
~~~

Once I was confident that I'd be able to authenticate, I tried using the `Get` method to retrieve all records for my domain:

~~~ powershell
Invoke-WebRequest https://api.godaddy.com/v1/domains/clintcolding.com/records/ -Method Get -Headers $Headers
~~~

The API successfully returned the data but in JSON, which was difficult to read in a POSH terminal:

~~~ powershell
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
~~~

I reran the command only this time I piped the output to `ConvertFrom-Json`:

~~~ powershell
Invoke-WebRequest https://api.godaddy.com/v1/domains/clintcolding.com/records/ -Method Get -Headers $Headers | ConvertFrom-Json
~~~

~~~ powershell
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
~~~
