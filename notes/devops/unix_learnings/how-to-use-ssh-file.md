#### Source : https://betterprogramming.pub/use-ssh-config-file-to-boost-your-productivity-b3867ce8cbfe

when the number of servers to manage increases, we’ll have to keep track of each server’s IP address as well as the permission file.This is where ssh config files come to resuce.
> touch ~/.ssh/config

Now the format for writing a remote host configuration inside a config file is as follows:
``` 
Host <server-alias>  
	HostName <server IP or url>  
	User <username>  
	IdentityFile <location of private key> 
```
example :
```
Host nano-server  
HostName 174.129.141.81  
User ubuntu  
IdentityFile ~/t3_nano_ssh_aws_keys.pem
```
>ssh nano-server

*** As seen above the parameters like `User` ,`IdentityFile` are not mandatory and their presence can vary from one configuration to another.***

Along with having multiple configurations we can also use a lot of wildcards while creating out configuration files

-   ( * ) Can be used as a substitute for one or more characters. For example in case there is a common `IdentityFile` for all dev servers, we can add the following line in config file:

```
Host dev-*  
  IdentityFile <location to identity file>
```

-   ( ? ) Can be used as a substitute for a single character. For example, in case we want to write configuration for all servers, with same prefix we can write:

```
Host ????-server  
  HostName 174.129.141.81  
  User ubuntu
  ```

We can connect to this server via command like `ssh nano-server` `tall-server` `omni-server` but not via `dev-server` as `dev` only contains 3 characters.

Based on these wildcards, we can write a sample configuration file as follows:
```
Host prod-server
  HostName xxx.xxx.xxx.xx
  User ubuntu
  IdentityFile ~/prod.pem
Host stag-server
  HostName xxx.xxx.xxx.xx
  User ubuntu
  IdentityFile ~/stag.pem
Host dev-server
  HostName xxx.xxx.xxx.xx
Host !prod-server
  LogLevel DEBUG
Host *-server
  IdentityFile ~/low-security.pem
```

