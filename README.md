# BetterPrivacy

> PowerShell script to improve your privacy on Windows 10 computers

## Description
With this script you can do the following to improve your privacy on Windows 10 computers:
* Disable services
* Remove apps
* Uninstall OneDrive
* Block telemetry domains
* Block telemetry IPs
* Change general privacy settings

![BetterPrivacy](http://i.imgur.com/DIFrgVL.png)

## System requirements
* Windows 10
* Administrator Account (self-elevating, no need to start as admin)
* Display resolution: 500x1100

## Usage
1. Download the complete repository
2. Make sure you extract all files to the same folder
3. Execute the batch file 'run.cmd'

use it at your own risk!

### Configuration
You can manually change the items of services, apps, domains and IPs inside the corresponding textboxes. Make sure that one entry is on one line, before you run the script by pressing the 'run' button.

If you want to add additional items permanently, you can do this by extending the 'conf.json' to fit your needs.

## Thanks to
* [W4RH4WK](https://github.com/W4RH4WK) for the awesome [Debloat-Windows-10](https://github.com/W4RH4WK/Debloat-Windows-10) scripts
* [10se1ucgo](https://github.com/10se1ucgo) for the base idea with his project [DisableWinTracking](https://github.com/10se1ucgo/DisableWinTracking)