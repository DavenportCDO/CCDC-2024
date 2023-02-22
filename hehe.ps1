net stop bthserv
net stop dns
net stop nettcpportsharing
net stop rasman
net stop remoteregistry


net start wuauserv
set-service wuauserv -StartupType Automatic
net start EventLog
set-service EventLog -StartupType Automatic
net start mpssvc
set-service mpssvc -StartupType Automatic
net start WdNisSvc
set-service WdNisSvc -StartupType Automatic
net start WinDefend
set-service WinDefend -StartupType Automatic

netsh advfirewall export "C:\Program Files\Common Files\default.wfw"
Remove-NetFirewallRule -All

# Baseline stuff, use on all machines
# New-NetFirewallRule -DisplayName "Internal traffic" -Direction Inbound -RemoteAddress "172.20.0.0" -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "HTTP(S) external outbound" -Direction Outbound -RemotePort 80,443 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DNS Client" -Program "C:\Windows\system32\svchost.exe" -Direction Outbound -RemotePort 53 -Protocol UDP -Action Allow
# New-NetFirewallRule -DisplayName "Internal traffic out" -Direction Outbound -RemoteAddress "172.20.0.0" -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "ICMPv4 IN" -Direction Inbound -Protocol ICMPv4 -Action Allow
New-NetFirewallRule -DisplayName "ICMPv6 IN" -Direction Inbound -Protocol ICMPv6 -Action Allow
New-NetFirewallRule -DisplayName "ICMPv4 OUT" -Direction Outbound -Protocol ICMPv4 -Action Allow
New-NetFirewallRule -DisplayName "ICMPv6 OUT" -Direction Outbound -Protocol ICMPv6 -Action Allow

# Critical services, only uncomment the ones you need
# New-NetFirewallRule -DisplayName "HTTP server" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "HTTPS server" -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "FTP server IN" -Program "C:\Windows\system32\svchost.exe" -Direction Inbound -LocalPort 20,21,1024-65535 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "FTP server OUT" -Program "C:\Windows\system32\svchost.exe" -Direction Outbound -LocalPort 20 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "DNS server" -Program "C:\Windows\system32\dns.exe" -Direction Inbound -LocalPort 53 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "DNS server" -Program "C:\Windows\system32\dns.exe" -Direction Inbound -LocalPort 53 -Protocol UDP -Action Allow
# New-NetFirewallRule -DisplayName "RDP server" -Program "C:\Windows\system32\svchost.exe" -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "RDP server" -Program "C:\Windows\system32\svchost.exe" -Direction Inbound -LocalPort 3389 -Protocol UDP -Action Allow
# New-NetFirewallRule -DisplayName "SMB server" -Direction Inbound -LocalPort 445 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "SSH server" -Direction Inbound -LocalPort 22 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "SMTP server" -Direction Inbound -LocalPort 23,110,143,465,587,993,995,2525 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "DHCP server" -Direction Inbound -LocalPort 67,68 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "DHCP server" -Direction Inbound -LocalPort 67,68 -Protocol UDP -Action Allow
# New-NetFirewallRule -DisplayName "POP3 scoring" -Direction Inbound -LocalPort 110 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "POP3 scoring" -Direction Outbound -LocalPort 110 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "POP3 scoring UDP" -Direction Inbound -LocalPort 110 -Protocol UDP -Action Allow
# New-NetFirewallRule -DisplayName "POP3 scoring UDP" -Direction Outbound -LocalPort 110 -Protocol UDP -Action Allow
# New-NetFirewallRule -DisplayName "Docker engine" -Direction Inbound -LocalPort 2375 -Action Allow
# New-NetFirewallRule -DisplayName "Docker stuff" -Direction Inbound -LocalPort 53 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName "Docker stuff" -Direction Inbound -LocalPort 53 -Protocol UDP -Action Allow