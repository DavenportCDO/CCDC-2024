#!/bin/bash

#Run this script as sudo and use the tee command to output to a text file ex) ./script.sh | tee out.txt

echo -e 'Please Choose an option:\n1.Run Enumeration Script\n2.Create an Encrypted Backup\n3.Restore from Encrypted Backup\n4.List Installed Packages\n5.Turn Off UFW/Firewalld\n6.Change Passwords for all non-root/non-system users'
read mode_select

#echo -e "Did you check the hash of this file before running it? (Enter for yes, Ctrl +C for No)"
#read hash_check

#echo -e "Are you running as sudo/root? (Enter for yes, Ctrl +C for No)"
#read sudo_check

if [ $mode_select == 1 ]; then
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
      iptables -L
    fi
    echo "===============================End===================================="

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
      iptables -L
    fi
    echo "===============================End===================================="

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
      iptables -L
    fi
    echo "===============================End===================================="

    elif [[ "$distro" =~ "centos" ]]; then
    echo ""
    echo "This is a CentOS System."
    echo ======================================================================================
    centhash=$(cat /etc/passwd | cut -d: -f1 | md5sum | cut -d" " -f1)
    echo "Hash of current users: "$centhash
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
      iptables -L
    fi
    echo "===============================End===================================="
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
    echo ======================================================================================
    echo "Installed Packages"
    dpkg -list
    echo "===============================End===================================="


  else
    echo "I do not recognize this OS"
  fi
elif [ $mode_select == 2 ]; then
  echo "Which directory would you like to backup and encrypt (ex. /var/www)?"
  read dir_selection
  echo "Is this correct " $dir_selection " (y/n)?"
  read confirmation
  if [ $confirmation == 'y' ]; then
    tar -C $dir_selection -cvf archive.tar ./
    gpg -c --no-symkey-cache -o archive.gpg archive.tar
    rm archive.tar
    echo "=========Backup complete, rename file as necessary (ex. var_www.gpg)========="
  else
    exit
  fi

elif [ $mode_select == 3 ]; then
  echo "What is the name of the encrypted backup file (easiest if file is in this directory)?"
  read restore_file
  echo "Is this correct " $restore_file " (y/n)?"
  read restore_file_confirmation
  if [ $restore_file_confirmation == 'y' ]; then
    echo "What was the path of the directory backed up (ex. /var/www)?"
    read restore_dir
    echo "Is this correct " $restore_dir " ? (y/n)"
    read restore_dir_confirmation
    if [ $restore_dir_confirmation == 'y' ]; then
      gpg --no-symkey-cache --output archive.tar --decrypt $restore_file
      mv archive.tar $restore_dir
      tar -C $restore_dir -xvf $restore_dir/archive.tar
      rm $restore_dir/archive.tar
      echo "========Restoration complete=========="
    fi
  fi
elif [ $mode_select == 4 ]; then
  if command -v rpm >/dev/null 2>&1; then
    echo "List of Installed packages can be found in the installed_packages.txt file."
    rpm -qa > installed_packages.txt
  elif command -v dpkg >/dev/null 2>&1; then
    echo "List of Installed packages can be found in the installed_packages.txt file."
    dpkg --list > installed_packages.txt
  else
    echo "=====Packages not installed via dpkg or rpm====="
  fi
elif [ $mode_select == 5 ]; then
  echo "Turning off UFW or Firewalld so we can use IPTables. This will also remove all IPTable rules at this time. Would you like to continue? (y,n)"
  read response
  if [ $response == 'y' ]; then
  if command -v ufw >/dev/null 2>&1; then
    systemctl stop ufw
    systemctl disable ufw
    apt install iptables-persistent
    iptables -F
    iptables -X
    clear
    echo "UFW has been disabled, would you like to initialise IPTables? WARNING THIS WILL BLOCK ALL TRAFFIC NOT SPECIFIED, ENSURE YOU HAVE A LIST OF ALL NECESSARY PORTS!!! (y,n)"
    read iptable_response
    ports_continue='y'
    if [ $iptable_response == 'y' ]; then
      systemctl enable iptables
      systemctl start iptables
      iptables -P INPUT DROP
      iptables -P OUTPUT DROP
      iptables -P FORWARD DROP
      #Disables IPv6
      ip6tables -P INPUT DROP
      ip6tables -P OUTPUT DROP
      ip6tables -P FORWARD DROP
      #Allows ICMP
      iptables -A INPUT -p icmp -j ACCEPT
      iptables -A OUTPUT -p icmp -j ACCEPT
      #Allows DNS
      iptables -A INPUT -p udp --sport 53 -j ACCEPT
      iptables -A INPUT -p udp --dport 53 -j ACCEPT
      iptables -A OUTPUT -p udp --sport 53 -j ACCEPT
      iptables -A OUTPUT -p udp --dport 53 -j ACCEPT


      while [ $ports_continue == 'y' ]
        do
          echo "Enter Port Number (Do not enter more than one port number at a time!)"
          read port_num
          echo "Would you like to allow tcp or udp traffic? (tcp/udp)"
          read traffic_type
          echo "Is this machine serving on this port, or connecting to a server on this port (s=serving,h=connecting)"
          read server_or_host
          if [ $server_or_host == 's' ]; then
            iptables -A INPUT -p $traffic_type --sport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
            iptables -A INPUT -p $traffic_type --dport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
            iptables -A OUTPUT -p $traffic_type --sport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
            iptables -A OUTPUT -p $traffic_type --dport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
          elif [ $server_or_host == 'h' ]; then
            iptables -A OUTPUT -p $traffic_type --dport $port_num -j ACCEPT
            iptables -A INPUT -p $traffic_type --sport $port_num -m state --state ESTABLISHED -j ACCEPT
          else
            echo "That is not a valid option, Rule not added, try again."
          fi
          echo "Port " $port_num " added."
          echo "Would you like to add another? (y,n)"
          read ports_continue
        done
      iptables-save > /etc/iptables/rules.v4
      echo "Rules saved to /etc/iptables/rules.v4"
    fi
  elif command -v firewalld >/dev/null 2>&1; then
    systemctl stop firewalld
    systemctl stop firewalld
    yum install iptables-services
    iptables -F
    iptables -X
    clear
    echo "Firewalld has been disabled, would you like to initialise IPTables? WARNING THIS WILL BLOCK ALL TRAFFIC NOT SPECIFIED, ENSURE YOU HAVE A LIST OF ALL NECESSARY PORTS!!! (y,n)"
    read iptable_response
    ports_continue='y'
    if [ $iptable_response == 'y' ]; then
      systemctl enable iptables
      systemctl start iptables
      iptables -P INPUT DROP
      iptables -P OUTPUT DROP
      iptables -P FORWARD DROP
      #Disables IPv6
      ip6tables -P INPUT DROP
      ip6tables -P OUTPUT DROP
      ip6tables -P FORWARD DROP
      #Allows ICMP
      iptables -A INPUT -p icmp -j ACCEPT
      iptables -A OUTPUT -p icmp -j ACCEPT
      #Allows DNS
      iptables -A INPUT -p udp --sport 53 -j ACCEPT
      iptables -A INPUT -p udp --dport 53 -j ACCEPT
      iptables -A OUTPUT -p udp --sport 53 -j ACCEPT
      iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
      while [ $ports_continue == 'y' ]
        do
          echo "Enter Port Number (Do not enter more than one port number at a time!)"
          read port_num
          echo "Would you like to allow tcp or udp traffic? (tcp/udp)"
          read traffic_type
          echo "Is this machine serving on this port, or connecting to a server on this port (s=serving,h=connecting)"
          read server_or_host
          if [ $server_or_host == 's' ]; then
            iptables -A INPUT -p $traffic_type --sport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
            iptables -A INPUT -p $traffic_type --dport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
            iptables -A OUTPUT -p $traffic_type --sport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
            iptables -A OUTPUT -p $traffic_type --dport $port_num -m state --state NEW,ESTABLISHED -j ACCEPT
          elif [ $server_or_host == 'h' ]; then
            iptables -A OUTPUT -p $traffic_type --dport $port_num -j ACCEPT
            iptables -A INPUT -p $traffic_type --sport $port_num -m state --state ESTABLISHED -j ACCEPT
          else
            echo "That is not a valid option, Rule not added, try again."
          fi
          echo "Port " $port_num " added."
          echo "Would you like to add another? (y,n)"
          read ports_continue
        done
      iptables-save > /etc/sysconfig/iptables
      echo "Rules saved to /etc/sysconfig/iptables"
    fi
  else
    echo "You will have to manually disable the firewall."
  fi
  fi
elif [ $mode_select == 6 ]; then
	echo "This will give you the option to encrypt the new passwords and upload them to bashupload.com so that they can be pulled down onto your host and sent to the judges from there. If you do not choose this option the script will still change all of the non-root/non-system user passwords and will put them in an encrypted zip file. You will then have to figure out how to get those passwords to the judges for scoring."
	echo "Are you running as root?(y,n)"
	read root_answer
	if [ $root_answer == 'y' ]; then
		if command -v zip >/dev/null 2>&1; then
			echo > new_pass.csv
			cat /etc/passwd | awk -F: ' $3 >= 1000 ' | grep -v "65534" | cut -d: -f1 > users.txt
			for i in $(cat users.txt)
			do
                pass=$(openssl rand -base64 15)
                echo $pass | passwd --stdin $i
                echo -n $i:$pass, >> new_pass.csv
			done
			echo "Passwords have been changed"
			echo "Encypting file, CHOOSE A GOOD PASSWORD!!!"
			zip -e new_pass.zip new_pass.csv
			rm new_pass.csv
			rm users.txt
			echo "Do you need to move this file off this machine?(y,n)"
			read upload
			if [ $upload == 'y' ]; then
                curl bashupload.com -T new_pass.zip | tee url.txt
                echo -e "\n\n\n"
                echo "!!!!!!!Go to the url in url.txt to download the file and unzip it!!!!!!!"
                echo "#######DELETE url.txt ONCE THE FILE HAS BEEN SUBMITTED TO THE JUDGES#######"
                echo -e "\n\n\n"
			else
                echo "You now have a zip file full of passwords, get that to the judges asap!!!!"
			fi
		else
			echo "Please install zip and run this again"
		fi
	fi
fi
