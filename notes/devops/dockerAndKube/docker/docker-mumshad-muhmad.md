`docker run redis:4.0`
_4.0_ is tag

```
docker exec -it my_new_container /bin/bash
```
```
docker container run -it [yourImage] bash
```
```
docker run -p [HOST_PORT]:[CONTAINER_PORT] [IMAGE]
```
```
docker run -v [host-folder-path]:[Container-path] [image]
```
eg: `docker run -it -v /home/gaurav/Documents/my_folder:/app --name container1 image_try1:v1 bash`
```
docker inspect [Container]
```
### Docker env variable
```bash
docker run -d -t -i -e REDIS_NAMESPACE='staging' \ 
-e POSTGRES_ENV_POSTGRES_PASSWORD='foo' \
-e POSTGRES_ENV_POSTGRES_USER='bar' \
-e POSTGRES_ENV_DB_NAME='mysite_staging' \
-e POSTGRES_PORT_5432_TCP_ADDR='docker-db-1.hidden.us-east-1.rds.amazonaws.com' \
-e SITE_URL='staging.mysite.com' \
-p 80:80 \ 
--name container_name dockerhub_id/image_name
```
```
 docker run --env-file ./my_env ubuntu bash
```

![[Pasted image 20240909230010.png]]
![[Pasted image 20240909230055.png]]
Override entry point:
````yaml
docker run --entrypoint <entrypoint.sh> <image:tag> <arg1> <arg2> <arg3>
````
![[Pasted image 20240909230207.png]]
![[Pasted image 20240909230429.png]]
![[Pasted image 20240909230511.png]]
![[Pasted image 20240909230650.png]]

### Volume mount vs bind mount
![[Pasted image 20240910075054.png]]
Volume mount: mounts volume from volumes directory
Bind mount: Mounts volume from any directory
New way to mount
![[Pasted image 20240910075435.png]]
![[Pasted image 20240910080459.png]]
![[Pasted image 20240910080536.png]]
![[Pasted image 20240910080725.png]]
![[Pasted image 20240910081307.png]]
![[Pasted image 20240910081633.png]]
![[Pasted image 20240910081700.png]]
![[Pasted image 20240910082028.png]]


