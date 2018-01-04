---
layout: post
title: 'Mocking Multiple Outputs'
categories:
- PowerShell
tags:
- Pester
- Mocking
excerpt: Lately, I've been diving into Pester and today I ran into a function that called the same command twice, each time outputting something different (or it should). The function tests and if needed attempts to correct the status of a service.
image: /images/thumbnails/posh.png
---

Lately, I've been diving into Pester and today I ran into a function that called the same command twice, each time outputting something different (or it should). The function tests and if needed attempts to correct the status of a service. Below is the specific scenario I was trying to simulate:

<center>
  <p>
    <div class="row">Tests the service with Get-Service.</div>
    <div class="row"><i class="fa fa-long-arrow-down" aria-hidden="true"></i></div>
    <div class="row">Service is stopped.</div>
    <div class="row"><i class="fa fa-long-arrow-down" aria-hidden="true"></i></div>
    <div class="row">Attempts to start service.</div>
    <div class="row"><i class="fa fa-long-arrow-down" aria-hidden="true"></i></div>
    <div class="row">Tests the service with Get-Service.</div>
    <div class="row"><i class="fa fa-long-arrow-down" aria-hidden="true"></i></div>
    <div class="row">Service is running.</div>
    <div class="row"><i class="fa fa-long-arrow-down" aria-hidden="true"></i></div>
    <div class="row">Script exits.</div>
  </p>
</center>

I was having a hard time with the fact that Get-Service was being run twice. The first time I needed it to return Stopped, but the second time Running. After a bit of research, I found an [example](https://groups.google.com/forum/#!topic/pester/HH0ANH1OiKY) using a [script scoped variable](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_scopes) as an execution counter. This is what it looks like:

~~~ powershell
Context 'When service is stopped and successfully started' {

### Initial count ###

  $Script:MockCounter = 0

  Mock -CommandName Get-Service -MockWith {

### Increments counter by 1 each time ###

    $Script:MockCounter++

### Mocks the first time Get-Service is run ###

    if ($Script:MockCounter -eq 0) {
        return @{Status='Stopped'}
    }

### Mocks the second time Get-Service is run ###

    if ($Script:MockCounter -eq 1) {
        return @{Status='Running'}
    }
  }
}
~~~

The first time Get-Service is mocked the counter is set to zero, returning `@{Status='Stopped'}`. `$Script:MockCounter++` is executed, setting the counter to one, mocking Get-Service with `@{Status='Running'}` the second time.

This is only the second Pester test I've written. If there's something I could have done better I'd love to know. You can contact me [@theclintcolding](https://twitter.com/theclintcolding) or leave a comment below!

You can find the complete function and tests on [Github](https://github.com/clintcolding/TheToolbox).