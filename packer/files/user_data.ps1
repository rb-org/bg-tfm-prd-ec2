<powershell>
$logfile='C:\ProgramData\Amazon\EC2-Windows\Launch\Log\kitchen-ec2.log'
# Allow script execution
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
#PS Remoting and & winrm.cmd basic config
Enable-PSRemoting -Force -SkipNetworkProfileCheck
#Extra WinRM Settings for CIS Hardened
Set-ItemProperty –Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service –Name AllowBasic –Value 1 –Type DWord
Set-ItemProperty –Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service –Name AllowUnencryptedTraffic –Value 1 –Type DWord
Set-ItemProperty –Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System –Name LocalAccountTokenFilterPolicy –Value 1 –Type DWord
#End CIS Hardened Settings
& winrm.cmd set winrm/config '@{MaxTimeoutms="1800000"}' >> $logfile
& winrm.cmd set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}' >> $logfile
& winrm.cmd set winrm/config/winrs '@{MaxShellsPerUser="50"}' >> $logfile
#Server settings - support username/password login
& winrm.cmd set winrm/config/service/auth '@{Basic="true"}' >> $logfile
& winrm.cmd set winrm/config/service '@{AllowUnencrypted="true"}' >> $logfile
& winrm.cmd set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}' >> $logfile
#Extra WinRM Settings for CIS Hardened
Set-ItemProperty –Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System –Name LocalAccountTokenFilterPolicy –Value 1 –Type DWord
#& winrm.cmd qc -Force >> $logfile
#Enable-PSRemoting -Force
#Firewall Config
& netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" profile=public protocol=tcp localport=5985 remoteip=localsubnet new remoteip=any  >> $logfile
</powershell>
#<runAsLocalSystem>true</runAsLocalSystem>
<persist>true</persist>
