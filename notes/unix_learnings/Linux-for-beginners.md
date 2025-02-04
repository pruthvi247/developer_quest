[source-FreeCodeCamp](https://www.freecodecamp.org/news/learn-linux-for-beginners-book-basic-to-advanced/?ref=dailydev#heading-part-2-introduction-to-bash-shell-and-system-commands)

![[Pasted image 20241217135225.png]]
  

|Location|Purpose|
|---|---|
|/bin|Essential command binaries|
|/boot|Static files of the boot loader, needed in order to start the boot process.|
|/etc|Host-specific system configuration|
|/home|User home directories|
|/root|Home directory for the administrative root user|
|/lib|Essential shared libraries and kernel modules|
|/mnt|Mount point for mounting a filesystem temporarily|
|/opt|Add-on application software packages|
|/usr|Installed software and shared libraries|
|/var|Variable data that is also persistent between boots|
|/tmp|Temporary files that are accessible to all users|

💡 **Tip:** You can learn more about the file system using the `man hier` command.

>You can check your file system using the `tree -d -L 1` command. You can modify the `-L` flag to change the depth of the tree.

|        |                         |
| ------ | ----------------------- |
| `cd -` | Go to the previous path |
💡**Tip:** You can differentiate between a file and folder by looking at the first letter in the output of `ls -l`. A`'-'` represents a file and a `'d'` represents a folder.

```bash
find /path/ -type f -name file-to-search
```
- `-type` represents the file descriptors. They can be any of the below:  
    `f` – **Regular file** such as text files, images, and hidden files.  
    `d` – **Directory**. These are the folders under consideration.  
    `l` – **Symbolic link**. Symbolic links point to files and are similar to shortcuts.  
    `c` – **Character devices**. Files that are used to access character devices are called character device files. Drivers communicate with character devices by sending and receiving single characters (bytes, octets). Examples include keyboards, sound cards, and the mouse.  
    `b` – **Block devices**. Files that are used to access block devices are called block device files. Drivers communicate with block devices by sending and receiving entire blocks of data. Examples include USB and CD-ROM
```bash
find . -type f -name "style*"
#output
./style.css
./styles.css
```
```bash
find . -type f -name "*.conf"
```


**Search hidden files :**
```bash
find . -type f -name ".*"
```
list hidden files : `ls -la`
**search files by size**
```bash
find / -size +250M
```
```bash
find <directory> -type f -size +N<Unit Type>
```
**search files by modification time**
```bash
find /path -name "*.txt" -mtime -10
```
- **-mtime +10**  means you are looking for a file modified 10 days ago.
- **-mtime -10**  means less than 10 days.
- **-mtime 10**  If you skip + or – it means exactly 10 days.


**VIM Navigation
💡**Tip: To remember the `hjkl` sequence, use this: **h**ang back, **j**ump down, **k**ick up, **l**eap forward.

- **Basic Navigation**
    - `h`: Move left
    - `j`: Move down
    - `k`: Move up
    - `l`: Move right
    - `0`: Move to the beginning of the line
    - `$`: Move to the end of the line
    - `gg`: Move to the beginning of the file
    - `G`: Move to the end of the file
    - `Ctrl+d`: Move half-page down
    - `Ctrl+u`: Move half-page up
- **Searching and Replacing**
    - `/`: Search for a pattern which will take you to its next occurrence
    - `?`: Search for a pattern that will take you to its previous occurrence
    - `n`: Repeat the last search in the same direction
    - `N`: Repeat the last search in the opposite direction
    - `:%s/old/new/g`: Replace all occurrences of `old` with `new` in the file
- **Multiple Windows**
    - `:split` or `:sp`: Split the window horizontally
    - `:vsplit` or `:vsp`: Split the window vertically
    - `Ctrl+w followed by h/j/k/l`: Navigate between split windows
## Part 6: Bash Scripting

1. Gathering input from terminal/user
```bash
#!/bin/bash
echo "What's your name?"
read entered_name
echo -e "\nWelcome to bash tutorial" $entered_name
```
2. Reading from file
```bash
while read line
do
  echo $line
done < input.txt
```
3. Command line argument
```bash
#!/bin/bash
echo "Hello, $1!"
```
4. Conditional statement
```bash
if [[ condition ]];
then
    statement
elif [[ condition ]]; then
    statement 
else
    do this by default
fi
```
AND or OR conditions
```bash
if [ $a -gt 60 -a $b -lt 100 ]
```

```bash
#!/bin/bash

# Script to determine if a number is positive, negative, or zero

echo "Please enter a number: "
read num

if [ $num -gt 0 ]; then
  echo "$num is positive"
elif [ $num -lt 0 ]; then
  echo "$num is negative"
else
  echo "$num is zero"
fi
```

5. looping and branch 
```bash
#!/bin/bash
i=1
while [[ $i -le 10 ]] ; do
   echo "$i"
  (( i += 1 ))
done
```
for loop
```bash
#!/bin/bash

for i in {1..5}
do
    echo $i
done
```
Case Statement
```bash
case expression in
    pattern1)
        # code to execute if expression matches pattern1
        ;;
    pattern2)
        # code to execute if expression matches pattern2
        ;;
    pattern3)
        # code to execute if expression matches pattern3
        ;;
    *)
        # code to execute if none of the above patterns match expression
        ;;
esac
```
eg : 
```bash
fruit="apple"

case $fruit in
    "apple")
        echo "This is a red fruit."
        ;;
    "banana")
        echo "This is a yellow fruit."
        ;;
    "orange")
        echo "This is an orange fruit."
        ;;
    *)
        echo "Unknown fruit."
        ;;
esac
```
### Installing downloaded packages from a website

You may want to install a package you have downloaded from a website, rather than from a software repository. These packages are called `.deb` files.

**Using**`dpkg`**to install packages:**`dpkg` is a command-line tool used to install packages. To install a package with **dpkg**, open the Terminal and type the following:
```bash
cd directory
sudo dpkg -i package_name.deb
```
## User Management
here are three main types of user accounts:

1. **Superuser**: The superuser has complete access to the system. The name of the superuser is `root`. It has a `UID` of 0.
2. **System user**: The system user has user accounts that are used to run system services. These accounts are used to run system services and are not meant for human interaction.
3. **Regular user**: Regular users are human users who have access to the system.
The `id` command displays the user ID and group ID of the current user.
```bash
id
uid=1000(john) gid=1000(john) groups=1000(john),4(adm),24(cdrom),27(sudo),30(dip)... output truncated
```
To view the basic information of another user, pass the username as an argument to the `id` command.
```bash
id username
```
To view user-related information for processes, use the `ps` command with the `-u` flag.
```bash
ps -u
# Output
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  16968  3920 ?        Ss   18:45   0:00 /sbin/init splash
root         2  0.0  0.0      0     0 ?        S    18:45   0:00 [kthreadd]
```
By default, systems use the `/etc/passwd` file to store user information.

Here is a line from the `/etc/passwd` file:
```bash
root:x:0:0:root:/root:/bin/bash
```
The `/etc/passwd` file contains the following information about each user:

1. Username: `root` – The username of the user account.
2. Password: `x` – The password in encrypted format for the user account that is stored in the `/etc/shadow` file for security reasons.
3. User ID (UID): `0` – The unique numerical identifier for the user account.
4. Group ID (GID): `0` – The primary group identifier for the user account.
5. User Info: `root` – The real name for the user account.
6. Home directory: `/root` – The home directory for the user account.
7. Shell: `/bin/bash` – The default shell for the user account. A system user might use `/sbin/nologin` if interactive logins are not allowed for that user.
#### What is a group?

A group is a collection of user accounts that share access and resources. Groups have group names to identify them. The system identifies groups by a unique number called the group ID (GID).

```bash
adm:x:4:syslog,john
```
Here is the breakdown of the fields in the given entry:

1. Group name: `adm` – The name of the group.
2. Password: `x` – The password for the group is stored in the `/etc/gshadow` file for security reasons. The password is optional and appears empty if not set.
3. Group ID (GID): `4` – The unique numerical identifier for the group.
4. Group members: `syslog,john` – The list of usernames that are members of the group. In this case, the group `adm` has two members: `syslog` and `john`.

The groups are further divided into '_primary'_ and '_supplementary'_ groups.

- Primary Group: Each user is assigned one primary group by default. This group usually has the same name as the user and is created when the user account is made. Files and directories created by the user are typically owned by this primary group.
- Supplementary Groups: These are extra groups a user can belong to in addition to their primary group. Users can be members of multiple supplementary groups. These groups let a user have permissions for resources shared among those groups. They help provide access to shared resources without affecting the system’s file permissions and keeping the security intact. While a user must belong to one primary group, belonging to supplementary groups is optional.
![[Pasted image 20250204153340.png]]
##### How to change user and group ownership simultaneously
```bash
chown user:group filename
```
##### How to change directory ownership
```bash
chown -R admin /opt/script
```
##### How to change group ownership
In case we only need to change the group owner, we can use `chown` by preceding the group name by a colon `:`
```bash
chown :admins /opt/script
```
Running commands with `sudo` is a safer option rather than running the commands as the `root` user. This is because, only a specific set of users can be granted permission to run commands with `sudo`. This is defined in the `/etc/sudoers` file.
### Managing local user accounts

##### Creating users from the command line

```bash
sudo useradd username
```
The `usermod` command is used to modify existing users. Here are some of the common options used with the `usermod` command:
1. **Change a user's login name:**
    ```bash
     sudo usermod -l newusername oldusername
    ```
2. **Change a user's home directory:**
    ```bash
     sudo usermod -d /new/home/directory -m username
    ```
3. **Add a user to a supplementary group:**
    ```bash
     sudo usermod -aG groupname username
    ```
4. **Change a user's shell:**
    ```bash
     sudo usermod -s /bin/bash username
    ```
5. **Lock a user's account:**
    ```bash
     sudo usermod -L username
    ```
6. **Unlock a user's account:**
    ```bash
     sudo usermod -U username
    ```
7. **Set an expiration date for a user account:**
    ```bash
     sudo usermod -e YYYY-MM-DD username
    ```
8. **Change a user's user ID (UID):**
    ```bash
     sudo usermod -u newUID username
    ```
9. **Change a user's primary group:**
    ```bash
     sudo usermod -g newgroup username
    ```
10. **Remove a user from a supplementary group:**
    ```bash
    sudo gpasswd -d username groupname
    ```
    ##### Deleting users

The `userdel` command is used to delete a user account and related files from the system.

- `sudo userdel username`: removes the user's details from `/etc/passwd` but keeps the user's home directory.
    
- The `sudo userdel -r username` command removes the user's details from `/etc/passwd` and also deletes the user's home directory.
##### Changing user passwords
The `passwd` command is used to change a user's password.
- `sudo passwd username`: sets the initial password or changes the existing password of username. It is also used to change the password of the currently logged in user.
#### Text extraction using `grep`
Here are some common uses of `grep`:

1. **Search for a specific string in a file:**
    ```bash
     grep "search_string" filename
    ```
    This command searches for "search_string" in the file named `filename`.
2. **Search recursively in directories:**
    ```bash
     grep -r "search_string" /path/to/directory
    ```
    This command searches for "`search_string"` in all files within the specified directory and its subdirectories.
3. **Ignore case while searching:**
    ```bash
     grep -i "search_string" filename
    ```
    This command performs a case-insensitive search for "search_string" in the file named `filename`.
4. **Display line numbers with matching lines:**
    ```bash
     grep -n "search_string" filename
    ```
    This command shows the line numbers along with the matching lines in the file named `filename`.
5. **Count the number of matching lines:**
    ```bash
     grep -c "search_string" filename
    ```
    This command counts the number of lines that contain "search_string" in the file named `filename`.
6. **Invert match to display lines that do not match:**
    ```bash
     grep -v "search_string" filename
    ```
    This command displays all lines that do not contain "search_string" in the file named `filename`.
7. **Search for a whole word:**
    ```bash
     grep -w "word" filename
    ```
    This command searches for the whole word "word" in the file named `filename`.
    
8. **Use extended regular expressions:**
    ```bash
     grep -E "pattern" filename
    ```
    This command allows the use of extended regular expressions for more complex pattern matching in the file named `filename`.
    
**💡 Tip:** If there are multiple files in a folder, you can use the below command to find the list of files containing the desired strings.
```bash
# find the list of files containing the desired strings
grep -l "String to Match" /path/to/directory
```

#### Text extraction using `sed`
The basic syntax of `sed` is as follows:
```bash
sed [options] 'command' file_name
```
`sed`**usage:**

**1. Substitution:**
The `s` flag is used to replace text. The `old-text` is replaced with `new-text`:
```bash
sed 's/old-text/new-text/' filename
```
For example, to change all instances of "error" to "warning" in the log file `system.log`:
```bash
sed 's/error/warning/' system.log
```
**2. Printing lines containing a specific pattern:**
Using `sed` to filter and display lines that match a specific pattern:
```bash
sed -n '/pattern/p' filename
```
For instance, to find all lines containing "ERROR":
```bash
sed -n '/ERROR/p' system.log
```
**3. Deleting lines containing a specific pattern:**

You can delete lines from the output that match a specific pattern:
```bash
sed '/pattern/d' filename
```
For example, to remove all lines containing "DEBUG":
```bash
sed '/DEBUG/d' system.log
```
**4. Extracting specific fields from a log line:**
You can use regular expressions to extract parts of lines. Suppose each log line starts with a date in the format "YYYY-MM-DD". You could extract just the date from each line:
```bash
sed -n 's/^\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\).*/\1/p' system.log
```
#### Text parsing with `awk`

`awk` has the ability to easily split each line into fields. It's well-suited for processing structured text like log files.

The basic syntax of `awk` is:
```bash
awk 'pattern { action }' file_name
```
- **Accessing columns using**`awk`
	The fields in `awk` (separated by spaces by default) can be accessed using `$1`, `$2`, `$3`, and so on.
	
- **Print lines containing a specific pattern (for example, ERROR)**
```bash
awk '/ERROR/ { print $0 }' logfile.log

# output
2024-04-25 09:05:00 ERROR Network: Network timeout on request (ReqID: 456)
```
This prints all lines that contain "ERROR".
- **Extract the first field (Date and Time)**
```bash
awk '{ print $1, $2 }' logfile.log
```
- **Summarize occurrences of each log level**

```bash
awk '{ count[$3]++ } END { for (level in count) print level, count[level] }' logfile.log

```
```bash
# output
 1
WARN 1
ERROR 1
DEBUG 2
INFO 6
```
- **Filter out specific fields (for example, where the 3rd field is INFO)**

```bash
awk '{ $3="INFO"; print }' sample.log

# output
2024-04-25 09:00:00 INFO Startup: Application starting
2024-04-25 09:01:00 INFO Config: Configuration loaded successfully
2024-04-25 09:02:00 INFO Database: Database connection established
2024-04-25 09:03:00 INFO User: New user registered (UserID: 1001)
2024-04-25 09:04:00 INFO Security: Attempted login with incorrect credentials (UserID: 1001)
2024-04-25 09:05:00 INFO Network: Network timeout on request (ReqID: 456)
2024-04-25 09:06:00 INFO Email: Notification email sent (UserID: 1001)
2024-04-25 09:07:00 INFO API: API call with response time over threshold (Duration: 350ms)
2024-04-25 09:08:00 INFO Session: User session ended (UserID: 1001)
2024-04-25 09:09:00 INFO Shutdown: Application shutdown initiated
  INFO
```

This command will extract all lines where the 3rd field is "INFO".

💡 **Tip:** The default separator in `awk` is a space. If your log file uses a different separator, you can specify it using the `-F` option. For example, if your log file uses a colon as a separator, you can use `awk -F: '{ print $1 }' logfile.log` to extract the first field.
#### Understanding process creation and lifecycle

In Ubuntu, all processes originate from the initial system process called `systemd`, which is the first process started by the kernel during boot.

The `systemd` process has a process ID (PID) of `1` and is responsible for initializing the system, starting and managing other processes, and handling system services. All other processes on the system are descendants of `systemd`.

A parent process duplicates its own address space (fork) to create a new (child) process structure. Each new process is assigned a unique process ID (PID) for tracking and security purposes. The PID and the parent's process ID (PPID) are part of the new process environment. Any process can create a child process.

![[Pasted image 20250204154916.png]]
Through the fork routine, a child process inherits security identities, previous and current file descriptors, port and resource privileges, environment variables, and program code. A child process may then execute its own program code.

Typically, a parent process sleeps while the child process runs, setting a request (wait) to be notified when the child completes.

Upon exiting, the child process has already closed or discarded its resources and environment. The only remaining resource, known as a zombie, is an entry in the process table. The parent, signaled awake when the child exits, cleans the process table of the child's entry, thus freeing the last resource of the child process. The parent process then continues executing its own program code.

#### Understanding process states

Processes in Linux assume different states during their lifecycle. The state of a process indicates what the process is currently doing and how it is interacting with the system. The processes transition between states based on their execution status and the system's scheduling algorithm.

![[Pasted image 20250204154953.png]]
The processes in a Linux system can be in one of the following states:

| **State**                          | **Description**                                                                                                                                 |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **(new)**                          | Initial state when a process is created via a fork system call.                                                                                 |
| **Runnable (ready) (R)**           | Process is ready to run and waiting to be scheduled on a CPU.                                                                                   |
| **Running (user) (R)**             | Process is executing in user mode, running user applications.                                                                                   |
| **Running (kernel) (R)**           | Process is executing in kernel mode, handling system calls or hardware interrupts.                                                              |
| **Sleeping (S)**                   | Process is waiting for an event (for example, I/O operation) to complete and can be easily awakened.                                            |
| **Sleeping (uninterruptible) (D)** | Process is in an uninterruptible sleep state, waiting for a specific condition (usually I/O) to complete, and cannot be interrupted by signals. |
| **Sleeping (disk sleep) (K)**      | Process is waiting for disk I/O operations to complete.                                                                                         |
| **Sleeping (idle) (I)**            | Process is idle, not doing any work, and waiting for an event to occur.                                                                         |
| **Stopped (T)**                    | Process execution has been stopped, typically by a signal, and can be resumed later.                                                            |
| **Zombie (Z)**                     | Process has completed execution but still has an entry in the process table, waiting for its parent to read its exit status.                    |
The processes transition between these states in the following ways:

| **Transition**            | **Description**                                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Fork**                  | Creates a new process from a parent process, transitioning from (new) to Runnable (ready) (R).                     |
| **Schedule**              | Scheduler selects a runnable process, transitioning it to Running (user) or Running (kernel) state.                |
| **Run**                   | Process transitions from Runnable (ready) (R) to Running (kernel) (R) when scheduled for execution.                |
| **Preempt or Reschedule** | Process can be preempted or rescheduled, moving it back to Runnable (ready) (R) state.                             |
| **Syscall**               | Process makes a system call, transitioning from Running (user) (R) to Running (kernel) (R).                        |
| **Return**                | Process completes a system call and returns to Running (user) (R).                                                 |
| **Wait**                  | Process waits for an event, transitioning from Running (kernel) (R) to one of the Sleeping states (S, D, K, or I). |
| **Event or Signal**       | Process is awakened by an event or signal, moving it from a Sleeping state back to Runnable (ready) (R).           |
| **Suspend**               | Process is suspended, transitioning from Running (kernel) or Runnable (ready) to Stopped (T).                      |
| **Resume**                | Process is resumed, moving from Stopped (T) back to Runnable (ready) (R).                                          |
| **Exit**                  | Process terminates, transitioning from Running (user) or Running (kernel) to Zombie (Z).                           |
| **Reap**                  | Parent process reads the exit status of the zombie process, removing it from the process table.                    |
`ps aux` displays all processes running on the system.
The output above shows a snapshot of the currently running processes on the system. Each row represents a process with the following columns:

1. `USER`: The user who owns the process.
2. `PID`: The process ID.
3. `%CPU`: The CPU usage of the process.
4. `%MEM`: The memory usage of the process.
5. `VSZ`: The virtual memory size of the process.
6. `RSS`: The resident set size, that is the non-swapped physical memory that a task has used.
7. `TTY`: The controlling terminal of the process. A `?` indicates no controlling terminal.
8. `STAT`: The process state.
    - `R`: Running
    - `I` or `S`: Interruptible sleep (waiting for an event to complete)
    - `D`: Uninterruptible sleep (usually IO)
    - `T`: Stopped (either by a job control signal or because it is being traced)
    - `Z`: Zombie (terminated but not reaped by its parent)
    - `Ss`: Session leader. This is a process that has started a session, and it is a leader of a group of processes and can control terminal signals. The first `S` indicates the sleeping state, and the second `s` indicates it is a session leader.   
9. `START`: The starting time or date of the process.
10. `TIME`: The cumulative CPU time.
11. `COMMAND`: The command that started the process.

`&` at the end of each command moves the process to the background.
Use the `jobs` command to display the list of background jobs.
```bash
jobs
[1]   Running                 sleep 300 &
[2]-  Running                 sleep 400 &
[3]+  Running                 sleep 500 &
```

 Bring a Background Job to the Foreground
 ```bash
fg %1
```
This will bring job `1` to the foreground.

**Move the Foreground Job Back to the Background**
While the job is running in the foreground, you can suspend it and move it back to the background by pressing `Ctrl+Z` to suspend the job.
```bash
zaira@zaira:~$ fg %1
sleep 300

^Z
[1]+  Stopped                 sleep 300

zaira@zaira:~$ jobs
# suspended job 
[1]+  Stopped                 sleep 300
[2]   Running                 sleep 400 &
[3]-  Running                 sleep 500 &
```
Now use the `bg` command to resume the job with ID 1 in the background.
```bash
# Press Ctrl+Z to suspend the foreground job
# Then, resume it in the background
bg %1
```
**Kill all processes owned by a specific user:**

```bash
 pkill -u username
```
Here is the information about the `kill` command options and signals in a tabular form: This table summarizes the most common `kill` command options and signals used in Linux for managing processes.

|Command / Option|Signal|Description|
|---|---|---|
|`kill <pid>`|`SIGTERM`|Requests the process to terminate gracefully (default signal).|
|`kill -9 <pid>`|`SIGKILL`|Forces the process to terminate immediately without cleanup.|
|`kill -SIGKILL <pid>`|`SIGKILL`|Forces the process to terminate immediately without cleanup.|
|`kill -15 <pid>`|`SIGTERM`|Explicitly sends the `SIGTERM` signal to request graceful termination.|
|`kill -SIGTERM <pid>`|`SIGTERM`|Explicitly sends the `SIGTERM` signal to request graceful termination.|
|`kill -1 <pid>`|`SIGHUP`|Traditionally means "hang up"; can be used to reload configuration files.|
|`kill -SIGHUP <pid>`|`SIGHUP`|Traditionally means "hang up"; can be used to reload configuration files.|
|`kill -2 <pid>`|`SIGINT`|Requests the process to terminate (same as pressing `Ctrl+C` in terminal).|
|`kill -SIGINT <pid>`|`SIGINT`|Requests the process to terminate (same as pressing `Ctrl+C` in terminal).|
|`kill -3 <pid>`|`SIGQUIT`|Causes the process to terminate and produce a core dump for debugging.|
|`kill -SIGQUIT <pid>`|`SIGQUIT`|Causes the process to terminate and produce a core dump for debugging.|
|`kill -19 <pid>`|`SIGSTOP`|Pauses the process.|
|`kill -SIGSTOP <pid>`|`SIGSTOP`|Pauses the process.|
|`kill -18 <pid>`|`SIGCONT`|Resumes a paused process.|
|`kill -SIGCONT <pid>`|`SIGCONT`|Resumes a paused process.|
|`killall <name>`|Varies|Sends a signal to all processes with the given name.|
|`killall -9 <name>`|`SIGKILL`|Force kills all processes with the given name.|
|`pkill <pattern>`|Varies|Sends a signal to processes based on a pattern match.|
|`pkill -9 <pattern>`|`SIGKILL`|Force kills all processes matching the pattern.|
|`xkill`|`SIGKILL`|Graphical utility that allows clicking on a window to kill the corresponding process.|
**Redirection:** You can redirect the error and output streams to files or other commands. For example:

```bash
# Redirecting stdout to a file
ls > output.txt

# Redirecting stderr to a file
ls non_existent_directory 2> error.txt

# Redirecting both stdout and stderr to a file
ls non_existent_directory > all_output.txt 2>&1
```
- `2>&1:`: Here, `2` represents the file descriptor for standard error (`stderr`). `&1` represents the file descriptor for standard output (`stdout`). The `&` character is used to specify that `1` is not the file name but a file descriptor.
#### How to add cron jobs in Linux

First, to use cron jobs, you'll need to check the status of the cron service. If cron is not installed, you can easily download it through the package manager. Just use this to check:

```bash
# Check cron service on Linux system
sudo systemctl status cron.service
```
#### Cron job syntax

Crontabs use the following flags for adding and listing cron jobs:

- `crontab -e`: edits crontab entries to add, delete, or edit cron jobs.
- `crontab -l`: list all the cron jobs for the current user.
- `crontab -u username -l`: list another user's crons.
- `crontab -u username -e`: edit another user's crons.

When you list crons and they exist, you'll see something like this:
```bash
# Cron job example
* * * * * sh /path/to/script.sh
```
In the above example,
- `*` represents minute(s) hour(s) day(s) month(s) weekday(s), respectively. See details of these values below:
```markdown
*   *   *   *   *  sh /path/to/script/script.sh
|   |   |   |   |              |
|   |   |   |   |      Command or Script to Execute        
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |
|   |   |   | Day of the Week(0-6)
|   |   |   |
|   |   | Month of the Year(1-12)
|   |   |
|   | Day of the Month(1-31)  
|   |
| Hour(0-23)  
|
Min(0-59)
```
#### Cron job examples

Below are some examples of scheduling cron jobs.

|**SCHEDULE**|**SCHEDULED VALUE**|
|---|---|
|`5 0 * 8 *`|At 00:05 in August.|
|`5 4 * * 6`|At 04:05 on Saturday.|
|`0 22 * * 1-5`|At 22:00 on every day-of-week from Monday through Friday.|

#### How to set up a cron job

In this section, we will look at an example of how to schedule a simple script with a cron job.

1. Create a script called `date-script.sh` which prints the system date and time and appends it to a file. The script is shown below:
```bash
#!/bin/bash

echo `date` >> date-out.txt
```
2. Make the script executable by giving it execution rights.
```bash
chmod 775 date-script.sh
```
3. Add the script in the crontab using `crontab -e`.
Here, we have scheduled it to run per minute.
```bash
*/1 * * * * /bin/sh /root/date-script.sh
```
4. Check the output of the file `date-out.txt`. According to the script, the system date should be printed to this file every minute.
```bash
cat date-out.txt
# output
Wed 26 Jun 16:59:33 PKT 2024
Wed 26 Jun 17:00:01 PKT 2024
Wed 26 Jun 17:01:01 PKT 2024
Wed 26 Jun 17:02:01 PKT 2024
Wed 26 Jun 17:03:01 PKT 2024
Wed 26 Jun 17:04:01 PKT 2024
Wed 26 Jun 17:05:01 PKT 2024
Wed 26 Jun 17:06:01 PKT 2024
Wed 26 Jun 17:07:01 PKT 2024
```
**Check cron logs.**

First, you need to check if the cron has run at the intended time or not. In Ubuntu, you can verify this from the cron logs located at `/var/log/syslog`.

 **Redirect cron output to a file.**
You can redirect a cron's output to a file and check the file for any possible errors.
```bash
# Redirect cron output to a file
* * * * * sh /path/to/script.sh &> log_file.log
```
The output of the `ifconfig` command shows the network interfaces configured on the system, along with details such as IP addresses, MAC addresses, packet statistics, and more.

These interfaces can be physical or virtual devices.

To extract IPv4 and IPv6 addresses, you can use `ip -4 addr` and `ip -6 addr`, respectively.

**View network activity with**`netstat`

The `netstat` command shows network activity and stats by giving the following information:

Here are some examples of using the `netstat` command in the command line:

1. **Display all listening and non-listening sockets:**
    ```bash
     netstat -a
    ```
2. **Show only listening ports:**
    ```bash
     netstat -l
    ```
3. **Display network statistics:**
    ```bash
     netstat -s
    ```
4. **Show routing table:**
    ```bash
     netstat -r
    ```
5. **Display TCP connections:**
    ```bash
     netstat -t
    ```
6. **Display UDP connections:**
    ```bash
     netstat -u
    ```
7. **Show network interfaces:**
    ```bash
     netstat -i
    ```
8. **Display PID and program names for connections:**
    
    ```bash
     netstat -p
    ```
    
9. **Show statistics for a specific protocol (for example, TCP):**
    ```bash
     netstat -st
    ```
10. **Display extended information:**
    ```bash
    netstat -e
    ```
    ### Linux Troubleshooting: Tools and Techniques

#### System activity report with `sar`

The `sar` command in Linux is a powerful tool for collecting, reporting, and saving system activity information. It's part of the `sysstat` package and is widely used for monitoring system performance over time.

To use `sar` you first need to install `syssstat` using `sudo apt install sysstat`.

Once installed, start the service with `sudo systemctl start sysstat`.

Verify the status with `sudo systemctl status sysstat`.

Once the status is active, the system will start collecting various stats that you can use to access and analyze historical data

>**NOTE** Read more about sar package

