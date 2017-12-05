---
layout: post
title: 'Working with Environment Variables'
categories:
- PowerShell
tags:
excerpt:
---
#### Getting Variables

To view all of your environment variables run `dir env:`. This should return the *Names* and *Values* of all your environmnent variables.

To display all the values of a specific variable you can either use PowerShell's `$env` variable:

```
$env:Path.split(";")
```

Or the .NET method `GetEnvironmentVariable`:

```
[Environment]::GetEnvironmentVariable("Path").split(";")
```

Both will return and easy to read list of values for the Path variable.

#### Creating Variables

To create a new variable we can use the .NET method `SetEnvironmentVariable`:

```
[Environment]::SetEnvironmentVariable("TestVariable", "Test Value", "User")
```

Where *TestVariable* is our name, *Test Value* our value, and *User* creates a user-level variable. (Machine, User or Process)

#### Removing Variables

If we wanted to delete this variable we simply run the same command, this time setting the value to $null.

```
[Environment]::SetEnvironmentVariable("TestVariable", $null, "User")
```

You can confirm it was removed by using the Get method:

```
[Environment]::GetEnvironmentVariable("TestVariable", "User")
```

#### Adding Values

What if you wanted to add a new value to an existing variable while still preserving the current values? For example, we have an exisitng variable (MyVariable), with three values (Value1, Value2, Value3). And now we want to add Value4.

```
C:\> [Environment]::GetEnvironmentVariable("MyVariable", "User")
Value1; Value2; Value3
```

We could simply run the following command to overwrite the values:

```
[Environment]::SetEnvironmentVariable("MyVariable", "Value1;Value2;Value3;Value4", "User")
```

But if we had multiple lines of values this could get out of hand pretty quickly. Instead we can add our new value to `$env:MyVariable`:

```
[Environment]::SetEnvironmentVariable("MyVariable", $env:MyVariable + ";Value4", "User")
```

#### Removing Values

To remove a single value we have to rebuild our value list, excluding the value we want to remove. To do this we start by capturing our current values:

```
C:\> $values = [Environment]::GetEnvironmentVariable("MyVariable", "User")
C:\> $values
Value1;Value2;Value3;Value4
```

Next we split our values string, remove the value we want, and then rebuild our new string:

```
C:\> $values = ($values.Split(';') | Where-Object { $_ -ne 'Value4' }) -join ';'
C:\> $values
Value1;Value2;Value3
```

Using our new values, we can set the variable:

```
[Environment]::SetEnvironmentVariable("MyVariable", $values, "User")
```

And we can confirm by using the Get method:

```
C:\> [Environment]::GetEnvironmentVariable("MyVariable", "User")
Value1;Value2;Value3
```