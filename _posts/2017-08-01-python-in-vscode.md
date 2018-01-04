---
layout: post
title: 'Python in Visual Studio Code'
categories:
- Python
tags:
- VSCode
---

> A quick overview of setting up and running Python in Visual Studio Code on Windows 10...

### Installation

1. Install [VS Code](https://code.visualstudio.com/Download){:target="_blank"} and [Python](https://www.python.org/downloads/){:target="_blank"}.
2. Set environment variable via PowerShell:
```
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Python27\", "User")
```
3. Install pylint via Shell:
```
python -m pip install pylint
```
4. Install the VS Code Python [extension](https://marketplace.visualstudio.com/items?itemName=donjayamanne.python){:target="_blank"}.

### Running Code

When working with .py files your terminal should automatically update to Python.

{: .center}
![Python Terminal](/images/pythonterminal.png)

To run your code you can open the Command Palette `Ctrl+Shift+P` and search for *Python: Run Python File in Terminal*.

{: .center}
![Command Palette](/images/pythoncmdpalette.png)

You can also create a keybind:
- File <i class="fa fa-long-arrow-right" aria-hidden="true"></i> Preferences <i class="fa fa-long-arrow-right" aria-hidden="true"></i> Keyboard Shortcuts
- Search for *python.execInTerminal*

> Before running your code using this method, you must save your file each time.