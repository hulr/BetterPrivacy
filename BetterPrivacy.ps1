#region privileges
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
$arguments = "-ExecutionPolicy Bypass & '" + $MyInvocation.MyCommand.Definition + "'"
Start-Process powershell -Verb runAs -WindowStyle Hidden -ArgumentList $arguments
Break
}
#endregion

#region definitions
Add-Type -AssemblyName PresentationFramework
$conf = (Get-Content "$PSScriptRoot\conf.json") | ConvertFrom-Json
$log = "$PSScriptRoot\BetterPrivacy.log"

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="window" Title="BetterPrivacy" WindowStartupLocation ="CenterScreen"
		Height="500" Width="1100">
    <Grid>
        <TextBox Name="txtDisableServices" HorizontalAlignment="Left" Height="299" Margin="10,31,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="160" VerticalScrollBarVisibility="Auto" IsEnabled="{Binding ElementName=chkDisableServices, Path=IsChecked}" AcceptsReturn="True"/>
        <CheckBox Name="chkDisableServices" Content="disable services" HorizontalAlignment="Left" Margin="10,16,0,0" VerticalAlignment="Top" Width="150" Height="15"/>
        <TextBox Name="txtRemoveApps" HorizontalAlignment="Left" Height="299" Margin="175,31,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="237" VerticalScrollBarVisibility="Auto" IsEnabled="{Binding ElementName=chkRemoveApps, Path=IsChecked}" AcceptsReturn="True"/>
        <CheckBox Name="chkRemoveApps" Content="remove apps" HorizontalAlignment="Left" Margin="175,16,0,0" VerticalAlignment="Top" Width="150" Height="15"/>
		<TextBox Name="txtBlockDomains" HorizontalAlignment="Left" Height="299" Margin="417,31,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="284" VerticalScrollBarVisibility="Auto" IsEnabled="{Binding ElementName=chkBlockDomains, Path=IsChecked}" AcceptsReturn="True"/>
        <CheckBox Name="chkBlockDomains" Content="block domains" HorizontalAlignment="Left" Margin="417,16,0,0" VerticalAlignment="Top" Width="174" Height="15"/>
        <TextBox Name="txtBlockIPs" HorizontalAlignment="Left" Height="299" Margin="706,31,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="129" VerticalScrollBarVisibility="Auto" IsEnabled="{Binding ElementName=chkBlockIPs, Path=IsChecked}" AcceptsReturn="True"/>
        <CheckBox Name="chkBlockIPs" Content="block ips" HorizontalAlignment="Left" Margin="706,16,0,0" VerticalAlignment="Top" Width="150" Height="15"/>
        <CheckBox Name="chkTelemetry" Content="telemetry" HorizontalAlignment="Left" Margin="841,16,0,0" VerticalAlignment="Top" Height="15" Width="70"/>
        <Rectangle Name="rctTelemetry" HorizontalAlignment="Left" Height="299" Margin="841,31,0,0" Stroke="#FFABADB3" VerticalAlignment="Top" Width="235"/>
        <CheckBox Name="chktcTurnOffOneDriveFileSync" Content="turn off one drive file sync" HorizontalAlignment="Left" Margin="851,45,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcTurnOffAdvertisingId" Content="turn off advertising id" HorizontalAlignment="Left" Margin="851,65,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcTurnOffSmartScreenFilter" Content="turn off smartscreen filter" HorizontalAlignment="Left" Margin="851,85,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcPreventSitesToAccessLanguageList" Content="prevent sites to access language list" HorizontalAlignment="Left" Margin="851,105,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcDoNotShowFeedbackNotifications" Content="do not show feedback notifications" HorizontalAlignment="Left" Margin="851,125,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcTurnOffWiFiSense" Content="turn off wi-fi sense" HorizontalAlignment="Left" Margin="851,145,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcSetTelemetryLevelToSecurity" Content="set telemetry level to security" HorizontalAlignment="Left" Margin="851,165,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcDisableDefenderAntimalwareService" Content="disable defender antimalware service" HorizontalAlignment="Left" Margin="851,185,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcDoNotSubmitDefenderSamples" Content="do not submit defender samples" HorizontalAlignment="Left" Margin="851,205,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcDoNotReportInfectionInformation" Content="do not report infection information" HorizontalAlignment="Left" Margin="851,225,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcClearDiagTrackLog" Content="clear diagtrack log" HorizontalAlignment="Left" Margin="851,245,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcDisableSyncOfSettings" Content="disable sync of settings" HorizontalAlignment="Left" Margin="851,265,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <CheckBox Name="chktcDisableLocationSensor" Content="disable location sensor" HorizontalAlignment="Left" Margin="851,285,0,0" VerticalAlignment="Top" Height="15" Width="215" IsEnabled="{Binding ElementName=chkTelemetry, Path=IsChecked}"/>
        <TextBox Name="txtOutput" HorizontalAlignment="Left" Height="93" Margin="10,356,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="953" RenderTransformOrigin="1.458,0.696" VerticalScrollBarVisibility="Auto"/>
        <Label Name="lblOutput" Content="output" HorizontalAlignment="Left" Margin="10,330,0,0" VerticalAlignment="Top" Width="79" Height="26"/>
        <Button Name="btnReset" Content="reset" HorizontalAlignment="Left" Margin="978,356,0,0" VerticalAlignment="Top" Width="98" Height="40" FontWeight="Bold" RenderTransformOrigin="0.5,-0.1"/>
        <Button Name="btnRun" Content="run" HorizontalAlignment="Left" Margin="978,409,0,0" VerticalAlignment="Top" Width="98" Height="40" FontWeight="Bold"/>
    </Grid>
</Window>
'@
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$window=[Windows.Markup.XamlReader]::Load($reader)
ForEach($name in $window.Content.Children.Name) {
    $window | Add-Member NoteProperty -Name $name -Value $window.FindName($name) -Force
}
#endregion

#region functions
Function WriteOutput($msg) {
    $ps = [powershell]::create()
    $ps.Runspace.SessionStateProxy.SetVariable("window", $window)
    $ps.Runspace.SessionStateProxy.SetVariable("msg", $msg)
    $ps.AddScript({
        Write-Host $null
    })
    $ps.BeginInvoke()
    $window.Dispatcher.Invoke([action]{$window.txtOutput.Text += (Get-Date -Format "[HH:mm:ss] ")},"Render")
    $window.Dispatcher.Invoke([action]{$window.txtOutput.Text += $msg },"Render")
    $window.Dispatcher.Invoke([action]{$window.txtOutput.AppendText("`r`n")},"Render")
    $window.Dispatcher.Invoke([action]{$window.txtOutput.Focus()},"Render")
    $window.Dispatcher.Invoke([action]{$window.txtOutput.CaretIndex = $window.txtOutput.Text.Length},"Render")
    $window.Dispatcher.Invoke([action]{$window.txtOutput.ScrollToEnd()})
    $ps.Dispose()
}

Function LoadDefaultValues {
    $txtboxes = $window.Content.Children.Name -Like "txt*"
    ForEach ($txtbox in $txtboxes) {
        $window.$txtbox.Text = ""
    }
    $chkboxes = $window.Content.Children.Name -Like "chk*"
    ForEach ($chkbox in $chkboxes) {
        $window.$chkbox.IsChecked = $false
    }
	$services = $conf.service
	$services | ForEach-Object {
		$window.txtDisableServices.Text += $_
		$window.txtDisableServices.AppendText("`r`n")
	}
	$apps = $conf.app
	$apps | ForEach-Object {
		$window.txtRemoveApps.Text += $_
		$window.txtRemoveApps.AppendText("`r`n")
	}
	$domains = $conf.domain
	$domains | ForEach-Object {
		$window.txtBlockDomains.Text += $_
		$window.txtBlockDomains.AppendText("`r`n")
	}
	$ips = $conf.ip
	$ips | ForEach-Object {
		$window.txtBlockIPs.Text += $_
		$window.txtBlockIPs.AppendText("`r`n")
	}
}
#endregion

#region main
$window.Add_Loaded(
	{
		Try {
			LoadDefaultValues
		}
		Catch {
			WriteOutput $($_.Exception.Message)
		}
	}
)

$window.btnReset.add_Click(
	{
		Try {
			LoadDefaultValues
		}
		Catch {
			WriteOutput $($_.Exception.Message)
		}
	}
)

$window.chkTelemetry.add_Click(
    {
        Try {
            If ($window.chkTelemetry.IsChecked -eq $true) {
                $chkboxes = $window.Content.Children.Name -Like "chktc*"
                ForEach ($chkbox in $chkboxes) {
                    $window.$chkbox.IsChecked = $true
                }
            } ElseIf ($window.chkTelemetry.IsChecked -eq $false) {
                $chkboxes = $window.Content.Children.Name -Like "chktc*"
                ForEach ($chkbox in $chkboxes) {
                    $window.$chkbox.IsChecked = $false
                }
            }
        }
        Catch {
            WriteOutput $($_.Exception.Message)
        }
    }
)

$window.btnRun.add_Click(
    {
        Try {
            WriteOutput "start"
            $btns = $window.Content.Children.Name -Like "btn*"
            ForEach ($btn in $btns) {
                $window.$btn.IsEnabled = $false
            }
            If ($($window.chkDisableServices.IsChecked) -eq $true -and $($window.txtDisableServices.Text.Replace("`r`n","")) -ne "") {
				$services = New-Object System.Collections.ArrayList
				(($window.txtDisableServices.Text.Replace("`r`n",",")).Split(",") | Where-Object { $_ -ne "" }) | ForEach-Object { $services.Add($_) }
                ForEach ($service in $services) {
                    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
                    if ($svc) {
                        if ($svc.Status -eq "Running") {
                            Stop-Service -Name $service -Force
                        }
                        Set-Service -Name $service -StartupType Disabled
                        WriteOutput "disabled service $($service)"
                    } Else {
                        WriteOutput "could not find service $($service)"
                    }
                }
            } Else {
                WriteOutput "you have not configured any services to disable"
            }
            If ($($window.chkRemoveApps.IsChecked) -eq $true -and $($window.txtRemoveApps.Text.Replace("`r`n","")) -ne "") {
				$apps = New-Object System.Collections.ArrayList
				(($window.txtRemoveApps.Text.Replace("`r`n",",")).Split(",") | Where-Object { $_ -ne "" }) | ForEach-Object { $apps.Add($_) }
                ForEach ($app in $apps) {
                    $a = Get-AppxPackage -Name $app -ErrorAction SilentlyContinue
                    If ($a) {
                        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
                        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
                        WriteOutput "removed app $($app)"
                    } Else {
                        WriteOutput "could not find app $($app)"
                    }
                }
            } Else {
                WriteOutput "you have not configured any apps to remove"
            }
            If ($($window.chkBlockDomains.IsChecked) -eq $true -and $($window.txtBlockDomains.Text.Replace("`r`n","")) -ne "") {
				$domains = New-Object System.Collections.ArrayList
				(($window.txtBlockDomains.Text.Replace("`r`n",",")).Split(",") | Where-Object { $_ -ne "" }) | ForEach-Object { $domains.Add($_) }
                $hosts = "$env:SystemRoot\System32\drivers\etc\hosts"
                ForEach ($domain in $domains) {
	                If (-Not (Select-String -Path $hosts -Pattern "^0.0.0.0 $($domain)$")) {
		                Write-Output "0.0.0.0 $domain" | Out-File -Encoding ASCII -Append $hosts
	                    WriteOutput "blocked domain $($domain)"
                    } Else {
                        WriteOutput "could not block domain $($domain), already set in hosts file"
                    }
                }
            } Else {
                WriteOutput "you have not configured any domains to block"
            }
            If ($($window.chkBlockIPs.IsChecked) -eq $true -and $($window.txtBlockIPs.Text.Replace("`r`n","")) -ne "") {
				$ips = New-Object System.Collections.ArrayList
                (($window.txtBlockIPs.Text.Replace("`r`n",",")).Split(",") | Where-Object { $_ -ne "" }) | ForEach-Object { $ips.Add($_) }
                ForEach ($ip in $ips) {
                    Remove-NetFirewallRule -DisplayName "BlockTelemetryIP-$($ip)" -ErrorAction SilentlyContinue
                    New-NetFirewallRule -DisplayName "BlockTelemetryIP-$($ip)" -Direction Outbound -Action Block -RemoteAddress $ip
                    WriteOutput "blocked ip $($ip)"
                }
            } Else {
                WriteOutput "you have not configured any ips to block"
            }
            If ($($window.chkTelemetry.IsChecked) -eq $true) {
                If ($($window.chktcTurnOffOneDriveFileSync.IsChecked) -eq $true) {
                    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "OneDrive" -Force
                    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Force
                    WriteOutput "turned off one drive file sync"
                }
                If ($($window.chktcTurnOffAdvertisingId.IsChecked) -eq $true) {
                    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\windows\CurrentVersion" -Name "AdvertisingInfo" -Value 0 -Force
                    WriteOutput "turned off advertising id"
                }
                If ($($window.chktcTurnOffSmartScreenFilter.IsChecked) -eq $true) {
                    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebcontentEvaluation" -Force
                    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation" -Name "Enabled" -Value 0 -Force
                    WriteOutput "turned off smartscreen filter"
                }
                If ($($window.chktcPreventSitesToAccessLanguageList.IsChecked) -eq $true) {
                    New-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Value 1 -Force
                    WriteOutput "configured computer to prevent websites to access language list"
                }
                If ($($window.chktcDoNotShowFeedbackNotifications.IsChecked) -eq $true) {
                    New-Item -Path "HKCU:\Software\Microsoft\Siuf" -Name "Rules" -Force
                    New-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Value 0 -Force
                    New-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Force
                    WriteOutput "configured computer to hide feedback notifications"
                }
                If ($($window.chktcTurnOffWiFiSense.IsChecked) -eq $true) {
                    $user = New-Object System.Security.Principal.NTAccount($env:UserName)
                    $sid = $user.Translate([System.Security.Principal.SecurityIdentifier]).Value
                    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Value 0 -Force
                    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features" -Name "WiFiSenseCredShared" -Value 0 -Force
                    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features" -Name "WiFiSenseOpen" -Value 0 -Force
                    New-Item -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features" -Name $sid -Force
                    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\$sid" -Name "FeatureStates" -Value 0x33c -Force
                    WriteOutput "turned off wi-fi sense"
                }
                If ($($window.chktcSetTelemetryLevelToSecurity.IsChecked) -eq $true) {
                    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
                    WriteOutput "set telemetry level to security (only available on windows 10 enterprise, windows 10 education, windows 10 mobile enterprise and iot core editions )"
                }
                If ($($window.chktcDisableDefenderAntimalwareService.IsChecked) -eq $true) {
                    If ((Test-Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -PathType Container) -eq $false) {
                        New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows Defender" -Name "Spynet" -Force
                    }
                    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -Name "SpyNetReporting" -Value 0 -Force
                    WriteOutput "disabled windows defender antimalware protection service"
                }
                If ($($window.chktcDoNotSubmitDefenderSamples.IsChecked) -eq $true) {
                    If ((Test-Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -PathType Container) -eq $false) {
                        New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows Defender" -Name "Spynet" -Force
                    }
                    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 2 -Force
                    WriteOutput "configured computer to stop sending windows defender file samples to microsoft"
                }
                If ($($window.chktcDoNotReportInfectionInformation.IsChecked) -eq $true) {
                    New-Item -Path "HKLM:\Software\Policies\Microsoft" -Name "MRT" -Force
                    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -Value 1 -Force
                    WriteOutput "configured computer to stop reporting infection information (malicious software reporting tool telemetry)"
                }
                If ($($window.chktcClearDiagTrackLog.IsChecked) -eq $true) {
                    $diaglog = "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
                    If (Test-Path $diaglog -PathType Leaf) {
                        Set-Content -Path $diaglog -Value "" -Force
                        WriteOutput "cleared diagtrack log"
                    } Else {
                        WriteOutput "diagtrack log not available @ $($diaglog)"
                    }
                }
                If ($($window.chktcDisableSyncOfSettings.IsChecked) -eq $true) {
                    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" -Name "BackupPolicy" -Value 0x3c -Force
                    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" -Name "DeviceMetadataUploaded" -Value 0 -Force
                    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" -Name "PriorLogons" -Value 1 -Force
                    $grps = @(("Accessibility"),("AppSync"),("BrowserSettings"),("Credentials"),("DesktopTheme"),("Language"),("PackageState"),("Personalization"),("StartLayout"),("Windows"))
                    ForEach ($grp in $grps) {
                        New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$grp" -Name "Enabled" -Value 0 -Force
                    }
                    WriteOutput "disabled synchronization of settings"
                }
                If ($($window.chktcDisableLocationSensor.IsChecked) -eq $true) {
                    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions" -Name "{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
                    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Value 0 -Force
                    WriteOutput "disabled location sensor"
                }
				$chkboxes = $window.Content.Children.Name -Like "chktc*"
                ForEach ($chkbox in $chkboxes) {
					If ($($window.$chkbox.IsChecked -eq $true)) {
						$i++
					}
                }
				If ($i -eq $null) {
					WriteOutput "you have not configured any general telemetry settings to change"
				}
            } Else {
                WriteOutput "you have not configured any general telemetry settings to change"
            }
            ForEach ($btn in $btns) {
                $window.$btn.IsEnabled = $true
            }
			WriteOutput "end, log file created @ $($log)"
            $window.txtOutput.Text | Out-File $log
        }
        Catch {
            WriteOutput $($_.Exception.Message)
            WriteOutput "end, log file created @ $($log)"
			$window.txtOutput.Text | Out-File $log
            $btns = $window.Content.Children.Name -Like "btn*"
            ForEach ($btn in $btns) {
                $window.$btn.IsEnabled = $true
            }
        }
    }
)
$window.ShowDialog() | Out-Null
#endregion
