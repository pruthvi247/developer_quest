![[Pasted image 20260126133716.png]]
- The root directory “/” is the starting point of the entire filesystem. From there, Linux organizes everything into specialized folders.
    
- “/boot” stores the bootloader and kernel files, without it, the system can’t start.
    
- “/dev” holds device files that act as interfaces to hardware.
    
- “/usr” contains system resources, libraries, and user-level applications.
    
- “/bin” and “/sbin” store essential binaries and system commands needed during startup or recovery.
    
- User-related data sits under “/home” for regular users and “/root” for the root account.
    
- System libraries that support core binaries live in “/lib” and “/lib64”.
    
- Temporary data is kept in “/tmp”, while “/var” tracks logs, caches, and frequently changing files.
    
- Configuration files live in “/etc”, and runtime program data lives in “/run”.
    
- Linux also exposes virtual filesystems through “/proc” and “/sys”, giving you insight into processes, kernel details, and device information.
    
- For external storage, “/media” and “/mnt” handle removable devices and temporary mounts, and “/opt” is where optional third-party software installs itself.
- 