#!/bin/bash

#Run this script as sudo and use the tee command to output to a text file ex) ./script.sh | tee out.txt

read -p "Did you check the hash of this file before running it (Enter for yes, Ctrl +C for No)?"

read -p "Are you running as sudo (Enter for yes, Ctrl +C for No)?"

os=$(uname -s)

if [ "$os" == "Linux" ]; then
  distro=$(cat /etc/os-release | grep ^ID= | awk -F "=" '{print $2}')

  if [ "$distro" == "ubuntu" ]; then
	echo ""
	echo "This is an Ubuntu System."
	echo ======================================================================================
	ubuntuhash=$(cat /etc/passwd | cut -d: -f1 | md5sum | cut -d" " -f1)
	echo "Hash of current users: "$ubuntuhash
	echo ======================================================================================
	echo "Sudoers"
	getent group sudo | cut -d: -f4
	echo ======================================================================================
	echo "SUID Files"
	find / -perm /u+s
	echo ======================================================================================
	echo "Running Services(First column):"
	systemctl list-unit-files | grep enabled | awk '$2 == "enabled"'
	echo ======================================================================================
	echo "All Cron Jobs"
	for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l | grep -v "#"; done
	echo ======================================================================================
	echo "Open Connections"
	netstat -atunlp
	echo ======================================================================================
	echo "Active firewall rules"
	if command -v ufw >/dev/null 2>&1; then
		ufw status numbered
	else
		iptables --L
	fi
	echo ======================================================================================
	
  elif [ "$distro" == "fedora" ]; then
	echo ""
	echo "This is an Fedora System."
	echo ======================================================================================
	fedorahash=$(cat /etc/passwd | cut -d: -f1 | md5sum | cut -d" " -f1)
	echo "Hash of current users: "$fedorahash
	echo ======================================================================================
	echo "Members of Wheel group (Sudoers)"
	getent group wheel | cut -d: -f4
	echo ======================================================================================
	echo "SUID Files:"
	find / -perm /u+s
	echo ======================================================================================
	echo "Running Services(First column):"
	systemctl list-unit-files | grep enabled | awk '$2 == "enabled"'
	echo ======================================================================================
	dnf install cronie cronie-anacron -y
	echo "All Cron Jobs"
	for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l; done
	echo ======================================================================================
	echo "Open Connections"
	netstat -atunlp
	echo ======================================================================================
	echo "Active Firewall rules"
	if command -v firewall-cmd >/dev/null 2>&1; then
		firewall-cmd --list-all
	else
		iptables --L
	fi
	echo ======================================================================================

  elif [ "$distro" == "debian" ]; then
	echo ""
	echo "This is an Debian System."
	echo ======================================================================================
	debianhash=$(cat /etc/passwd | cut -d: -f1 | md5sum | cut -d" " -f1)
	echo "Hash of current users: "$debianhash
	echo ======================================================================================
	echo "Sudoers"
	getent group sudo | cut -d: -f4
	echo ======================================================================================
	echo "SUID Files"
	find / -perm /u+s
	echo ======================================================================================
	echo "Running Services(First column):"
	systemctl list-unit-files | grep enabled | awk '$2 == "enabled"'
	echo ======================================================================================
	echo "All Cron Jobs"
	for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l | grep -v "#"; done
	echo ======================================================================================
	echo "Open Connections"
	netstat -atunlp
	echo ======================================================================================
	echo "Active firewall rules"
	if command -v ufw >/dev/null 2>&1; then
		ufw status numbered
	else
		iptables --L
	fi
	echo ======================================================================================
  fi
elif [[ "$os" == "FreeBSD" || "$os" == "OpenBSD" ]]; then
	echo ""
	echo "This is a $os system"
	echo ======================================================================================
	bsdhash=$(cat /etc/passwd | cut -d: -f1 | md5 | cut -d" " -f1)
	echo "Hash of current users: "$bsdhash
	echo ======================================================================================
	echo "Members of Wheel Group (Sudoers)"
	getent group wheel | cut -d: -f4
	echo ======================================================================================
	echo "SUID Files"
	find / -perm -4000
	echo ======================================================================================
	echo "Running Services"
	if [ $os == "OpenBSD" ]; then
		rcctl ls started
	elif [ $os == "FreeBSD" ]; then
		service -e
	else
		echo "Running Services can not be found"
	fi
	echo ======================================================================================
	echo "All Cron Jobs"
	for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l | grep -v "#"; done
	echo ======================================================================================
	echo "Open Connections"
	netstat -na | grep LISTEN 
	echo ======================================================================================
	echo "Use pfctl commands to look into firewall rules"

else
	echo "I do not recognize this OS"
fi
