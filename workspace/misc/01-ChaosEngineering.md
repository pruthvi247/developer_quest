The discipline of experimenting on a distributed system in order to build confidence in the system's capability to withstand turbulent conditions in production.

> Engineering breaking things on purpose to make them more resilient against failure

------------------------
[youtube-source](https://www.youtube.com/watch?v=w_Y6C0QgmL0)
Infrastructure resilience
Application resilience
Break things when every one is at the company


Chaos engineering is not about breaking things randomly without a purpose, chaos engineering is about breaking things in a controlled environment and the through well planned experiments in order to build confidence in your application to withstand turbulent conditions

![[Pasted image 20250314175511.png]]

![[Pasted image 20250314175700.png]]
## Hypothesis
![[Pasted image 20250314175826.png]]
- Do we have health checks for every micro service
## Run Experiments
### Rules of thumbs
- Start with very small
- As close as possible to production
- Minimise the blast radius 
- Check on cascading failures
- Have an emergency STOP
	- careful with state that can't be rolled back
		(corrupt or incorrect data)


### Quantify the result of the experiment

![[Pasted image 20250314180623.png]]
- Time to detect?
- Time for notification? and escalation
- Time to public notification
- Time for graceful degradation to kick-in?
- Time for self healing to happen 
- Time to recovery - partial and full 
- Time to clear-all and stable

Outage is not due to one single cause
![[Pasted image 20250314180740.png]]

# Bananas For Monkeys

1. Start with docker stop 

> `docker stop <dockerid>`

2. Ddos yourself
	This helps to check if we have rate limits
3. Adding Delay to the network(Latency)
	>tc qdisc add dev eth0 root netem delay 200ms
4. Burn CPU with Stress(-ng)
	>stress-ng --random 50 -t 60 --metrics-brief --times
5. Block DNS resolution
	> `iptables -I OUTPUT -p udp -d <DNS server IP> --dport 53 -j DROP`
6. Other fun things to do (use linux tools)
	1. Blocks DNS resolution
	2. fill up disk
	3. Network packet loss (using traffic-shaping)
	4. Network packet corruption (using traffic-shaping)
	5. kills random processes
	6. Detach all EBS/NFS volumes
	7. Mess with /etc/hosts

### Tools
https://chaostoolkit.org/
KubeMonkey
Thundra - Lamda
Amazon Aurora - sql fault injection
Pumba - docker chaos testing
**ToxiProxy**
![[Pasted image 20250314205448.png]]


Our goal:
 - Simplify adoption of chaos engineering
 

Chaos engineering won't make your system more robust **People** will













-------------------------------------