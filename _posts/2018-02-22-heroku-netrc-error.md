---
layout: post
title: 'Heroku NETRC Error'
categories:
- Heroku
tags:
- Heroku
- ENOENT
- netrc
---

I've been using the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) without issue for quite a while. However, today when I went to create a scheduled task I received an error, and quickly realized I was getting the same error even when just trying to login:

``` heroku
C:\WINDOWS\system32> heroku login
 !    ENOENT: ENOENT: no such file or directory, open 'H:\_netrc'
```

The **H** drive on my Windows 10 PC is a home drive mapped by active directory. After reading through the [netrc documentation](https://github.com/heroku/netrc), I found that the default location of the netrc file on Windows is:

```%NETRC%\_netrc```, ```%HOME%\_netrc```, ```%HOMEDRIVE%%HOMEPATH%\_netrc```, or ```%USERPROFILE%\_netrc``` (whichever is set first).

Obviously for me that happened to be the ```%HOMEDRIVE%%HOMEPATH%\_netrc```. To change which location is being used you either need to set the environmental variable for ```%NETRC%``` or ```%HOME%```, for example:

```
setx HOME %USERPROFILE%
```

Which sets the ```%HOME%``` environmental variable to your user profile. Now, if your home folder disconnects, Heroku CLI auth will continue to work.