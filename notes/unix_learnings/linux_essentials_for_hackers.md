[Source: https://www.freecodecamp.org/news/linux-essentials-for-hackers/]

> list subdirectories -> ls -lR

>> chmod u=rwx test.sh
>> chmod g=rwx test.sh
>> g- group,a-all,o-other
>> chomod g-wx test.sh

chown:

>> chown root test.sh
>> chgrp <user> <filename>

>> groups root -> will give the groups root user belongs to
>> groups pruthvi -> will give all the groups user pruthvi belongs to

>> ifconfig | grep "inet " | grep -v 127.0.0.1

enumerate kernal info:
>> uname -a -> unixname
> cat /etc/hostname
> cat /etc/hosts

Find:
>> find / -type -f -name "proxychains.conf"

>> find / -type -d -name "proxychains"

>> find / -type -d -perm 756
```bash
find / -size +250MB
```
Other units include:

-   `G`: GigaBytes.
-   `M`: MegaBytes.
-   `K`: KiloBytes
-   `b` : bytes.
### How to search files by modification time

```bash
find /path -name "*.txt" -mtime -10 
```
-   **-mtime +10** means you are looking for a file modified 10 days ago.
-   **-mtime -10** means less than 10 days.
-   **-mtime 10** If you skip + or – it means exactly 10 days.

>> find . -type -f -size 1033c ! -executable | xargs file

>> find / -user <username> -group <groupname> -size 33c

>> find . -not -type f

The -newer option in the find command searches for files that are modified after the last modification of the given file
>> find [path] -newer [reference_file]

To search for files that were accessed a few minutes ago, you can use the -amin argument. This argument will accept the number of minutes (n) and finds all the files that are accessed n minutes ago.

>> find . -amin -30

To search only for the empty directories, you can combine the -empty option with the -type option:
>> find . -type d -empty

For example, let's assume you want to search the files whose names start with the letter w. You can use the below command to do that:

>> find . -regex "./w.*"



Shells :
> user can change the default shell that needs to be used
> chsh -> command will help to change the default shell for a user
> du -sh * -> -s for summary

> du -sh * | grep "G"

> du -shc * -> -c for grand total

> df -ht ext4
> tar -cvf tarfilename.tar folder/
-c - compress
-v - verbose
-f - file
> tar -xvf tarfilename.tar
-x - extract
-v - verbose
-f -file
> tar -czf filename.tar.gz file/
> tar -xzf filename.tar.gz

>> usermod -aG <Group> <User>
after adding a user we have to create a folder on the home directory -> usermod -m -c "<user>" -s /bin/bash <user>
after adding user directory we have to set password

> passwd <user> -> This will promt to set a password

<user> is not in sudoers file, this incident will be reported -> particular user doesnt have sudo permissions

> su admin
> sudo visudo
add this line -> <user> ALL=(ALL) ALL
# we can also assign roles based on groups

How to add a group and a user to group:

> sudo groupadd <groupname> (Creates a group)

	> sudo  usermod -aG <group> <user>



	Netstat:

	> netstat -r
	> netstat -lt 
	-l - listening
	-t - tcp connections
	> netstat -lu
	-u - udp connections
	NetDiscover tool:
	> an active/passive arp reconnaissence tool.Allows to scan for networks and other devices connected to your network
	>> sudo  netdiscover -i enp2s0

	> In unix DNS mapping (ip to other router) is stored in /etc/resolv.conf

	/etc/hosts: Mapping between IP addresses & hostnames, for name resolution.

	127.0.0.1 localhost.localdomain localhost
	10.2.3.4 myhost.domain.org myhost


	/etc/resolv.conf: Domain names that must be appended to bare hostnames, and DNS servers that will be used for name resolution.

	search domain1.org domain2.org
	nameserver 192.168.3.3
	nameserver 192.168.4.4

	[link: https://askubuntu.com/questions/64535/network-configuration-resolv-conf-and-hosts]


	1) Normally your system would use the DNS server on your 'resolv.conf'. If you visit www.yahoo.com your system will contact the DNS, the DNS returns the IP address of that address and your systems then knows what IP address corresponds the address www.yahoo.com.

	2) It uses hosts before trying to resolve an address because hosts file is used to override any address you are trying to resolve. ie: you already have probably an entry there, 127.0.0.1 localhost tells the system that if you are trying to contact the host with the name "localhost" it will do so by using the address 127.0.0.1, in this case its your lopback interface on your eth0.

	3) After the system knows an address of a host either looking directly on your hosts or by contacting the DNS servers in 'resolv.conf' it will look at the routing table to see which of the rules explains what to do with the traffic with destination to the IP address obtained.

	Ie: Imagine you have 2 computers on your network with hostnames of "Ubuntu-One" and "Ubuntu-Two", each computer will probably have this assigned at the host file:

	127.0.0.1 localhost Ubuntu-One for computer Ubuntu-One 127.0.0.1 localhost Ubuntu-Two for computer Ubuntu-Two

	This is done automatic and its the reason you can resolve 'localhost' and 'Ubuntu-One" and "Ubuntu-Two" on each respective terminals.

	Try to ping Ubuntu-Two from Ubuntu-One and Ubuntu-One will contact the DNS servers at your resolv.conf file, the servers will say "I dont know any IP related to that address" and you PC will reply "Unknown hostname". Add the line <IPADDRESSFROMUBUNTU-TWO Ubuntu-Two to the hosts file of Ubuntu-One and one you try to ping again the system will see that on the hosts file the IP address from Ubuntu-Two is x.x.x.x, will then check your routing table to see which rule applies to that IP or IP range and will contact the host using the specified gateway (or none). Thats is why hosts is ever before resolv.conf.
	>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<
	> The xargs utility reads space, tab, newline and end-of-file delimited strings from the standard input and exe-
	cutes utility with the strings as arguments.

	>> find . -type -f -size 1033c

	process vs services:

	> When we start a service it will create a process.If we kill a process started by service, it will restart the process

	> sudo systemctl start ssh
> sudo systemctl is-enabled ssh.service (to check if service is enabled)
	> sudo systemctl enable ssh.service
	> sudo systemctl disable ssh.servie
	> sudo systemctl restart ssh.service
	> sudo systemctl reload ssh.service
	> sudo systemctl daemon-reload

	CURL:

	> curl -o <path/to/saveoutput> http://hoopapp-inc.com
	> curl -o <downloadfileas> <downloadable link>
	Dowload file with its original name

	> curl -O <link addres>

	If a website is getting redirected to another url, it is important to specify to curl

	> curl -L <http://hoop.com>

	analyse response headers
	> curl -I http://hoop.com
	To get the full details and TLS hand shake 
	> curl -v http://hoop.com

	> curl -data "username=abc&passwd=fjdlkaf" http://hoop.com (we can also send cookies)

	Uncomplicated firewall (UFW):

		> sudo ufw status
		> sudo ufw status verbose
		> sudo ufw status numbered

		> sudo ufw enable
		> sudo ufw disable
		> sudo ufw rest

		> sudo ufw default deny incoming
		> sudo ufw default allow incoming
		> sudo ufw allow ssh or sudo ufw allow 22
		> sudo ufw deny ssh or suedo ufw deny 22
		> sudo ufw allow http
		> sudo ufw allow https or sudo ufw allow 443
		> sudo ufw allow proto tcp from 192.168.0.0. to 172.178.2.2 port 80,44
		> sudo ufw allow proto tcp from any to any port 80,443
	> sudo ufw allow ftp or sudo ufw allow 21/tcp
> sudo ufw allow 3306 (mysql)
	> sudo ufw allow form 192.168.1.1
	> sudo ufw allow from 192.168.1.1/24
	> sudo ufw allow from 192.168.1.1/24 to any port 22

	> sudo ufw enable 
	> sudo ufw status numbered
	> sudo ufw delete <number>

	Clear trace and logs:

	> /var/log/auth.log

	> Shred is a tool to clear files
	overrides file repeatedly in order to make it harder for even very expensive hardware probing to recover the data.

	> shred -vfzu auth.log

	SSH Brute Force Protection With Fail2Ban:

	What is Fail2Ban ?
	> Fail2Ban is an intrusion prevention freamework written in python that protects linux systems and servers form brute-force attacks.
	> It allows you to monitor the strength and frequency of attacks
	> Fail2Ban can be setup to block IP address automatically based on specific parameters.































































