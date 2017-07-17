---
layout: post
title: 'Mocking: Same Command, Different Output'
categories:
- PowerShell
tags:
- Pester
---

Lately I've been diving into Pester and today I ran into a function that called the same command twice, each time outputting something different (or it should). The function tests and if needed attempts to correct the status of a service. Below is the specific workflow I was trying to simulate:

- Tests the service with Get-Service.
  - Service is stopped.
    - Attempts to start service.
      - Tests the service with Get-Service.
        - Service is running.
          - Script exits.

The part I was hung up on was the fact that Get-Service was being run twice. The first time I needed it to return Stopped, but the second time Running. After a bit of research I found an [example](https://groups.google.com/forum/#!topic/pester/HH0ANH1OiKY) using a script scoped variable as an execution counter. This is what it looks like:

~~~ posh
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

You can find the full function and tests on [Github](https://github.com/clintcolding/TheToolbox).

This is only the second Pester test I've written. If theres something I could have done better I'd love to know. You can contact me [@theclintcolding](https://twitter.com/theclintcolding) or leave a comment below!