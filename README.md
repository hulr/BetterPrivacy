# BetterPrivacy
for Windows 10

## Description
With this script you can do the following to improve your privacy on Windows 10 computers:
* Disable services
* Remove apps
* Block telemetry domains
* Block telemetry IPs
* Change general privacy settings

![BetterPrivacy](http://i.imgur.com/nVCRt33.png)

## System requirements
* Windows 10
* Windows PowerShell 5
* Administrator Account (self-elevating, no need to start as admin)
* Display resolution: 500x1100

## Usage
1. Download the complete repository
2. Make sure you extract all files to the same folder
3. Execute the batch file 'run.cmd'

use it at your own risk!

### Configuration
You can manually change the items of services, apps, domains and IPs inside the corresponding textboxes. Make sure that one entry is on one line, before you run the script by pressing the 'run' button.

If you wanna add additional items permanently, you can do this by extending the 'conf.json' to fit your needs.

## Thanks to
* [W4RH4WK](https://github.com/W4RH4WK) for the awesome [Debloat-Windows-10](https://github.com/W4RH4WK/Debloat-Windows-10) scripts
* [10se1ucgo](https://github.com/10se1ucgo) for the base idea with his project [DisableWinTracking](https://github.com/10se1ucgo/DisableWinTracking)

## License
    The MIT License (MIT)

    Copyright (c) 2016 hulr

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    