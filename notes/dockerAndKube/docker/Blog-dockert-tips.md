[source](https://aws.plainenglish.io/10-secrets-to-improve-your-dockerfile-40ac54aa5bf2)
[#goodread](https://docs.docker.com/engine/reference/builder/#healthcheck)

In this article, we’ll explore 10 things you might not know about Dockerfile, including tips and tricks for optimizing your builds, using multi-stage builds, and more. Whether you’re new to Docker or a seasoned pro, this article will help you take your Dockerfile skills to the next level.

# .dockerignore file

You can use a `**.dockerignore**` file to exclude files and directories from being copied into the build context, which can help keep the size of your build context smaller. This can be useful if there are large files or directories that you do not need to include in the image, as it will reduce the amount of data that needs to be transferred to the Docker daemon during the build.

_More info:_ [_https://_](https://docs.docker.com/engine/reference/builder/#dockerignore-file)[_docs.docker.com/engine/reference/builder/#dockerignore-file_](https://docs.docker.com/engine/reference/builder/#healthcheck)

# Use COPY over ADD

Both `**COPY**`and `**ADD**` instructions allow you to copy files and directories from the build context (host machine) into the image. However, there are some important differences between the two.

`**ADD**` has some additional features, that `**COPY**` doesn’t support such as:

- **Tar extraction**: the ability to automatically unpack compressed files (`**.tar**`, `**.tar.gz**`, `**.tgz**`, `**.tar.bz2**`, `**.tbz2**`)
- **Cache invalidation**: `**ADD**` invalidates the Docker build cache if the contents of the file at the `**<src>**` path change, whereas `**COPY**` does not. This means that if you make changes to the source file or directory, using `**ADD**` would trigger a rebuild of the Docker image, whereas `**COPY**` would not.
- **Permissions**: When using `**ADD**`, the permissions of the source file or directory are preserved, whereas with `**COPY**`, the permissions of the destination directory are set to `**755**` by default.
- **File URL support**: `**ADD**` supports the use of file URLs parameter. File URLs can be used to copy files from remote locations, such as from a website or a Git repository.

But the official documentation states that `COPY` instruction is preferred. That’s because it’s more transparent than `ADD` instruction which can have some unpredictable behavior.

_More info:_ [_https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy_](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy)

# Multi-stage builds

You can use multiple `**FROM**` statements in a single Dockerfile to create a multi-stage build, which allows you to build your application in one environment and then copy the result into a smaller, production-ready image.

This can be useful for reducing the size of the final image, as you can exclude intermediate build artifacts that are not needed for running the application.

# Stage 1: Build your golang executable  

```FROM golang as buildStage  
WORKDIR /app  
COPY . .  
RUN go build -o /go/bin/myapp  
  
# Stage 2: Run the application  
FROM alpine:latest  
COPY --from=buildStage /go/bin/myapp /usr/local/bin/myapp  
CMD ["myapp"]
```

_More info:_ [_https://docs.docker.com/build/building/multi-stage/_](https://docs.docker.com/build/building/multi-stage/)

# Multi-layers and caching

The instructions `RUN`, `COPY`, `ADD` create layers. Other instructions create temporary intermediate images and don’t increase the size of the build.

These layers are cached. This means that if you make a change to your Dockerfile and then build the image again, Docker will only rebuild the layers that have changed. This can save time, as subsequent builds will be faster. The cache is invalidated if the contents of a layer change, such as if a file is added, modified, or deleted. If you want to perform the complete procedure again, add `“—nocache option”` it to the docker build.

Some of the best practices are to avoid multi-layer images. Don’t run multiple RUN commands. Connect them using && (eg: `RUN yum —disablerepo=*, —enablerepo=”myrepo” && yum update -y && yum install nmap`) the result is one single layer. (to maintain readability, write the commands on different lines using && \ at the end of each line.

Where possible, use [multi-stage builds](https://docs.docker.com/build/building/multi-stage/), and only copy the artifacts you need into the final image. This allows you to include tools and debug information in your intermediate build stages without increasing the size of the final image.

_More info:_ [_https://docs.docker.com/build/cache/_](https://docs.docker.com/build/cache/)

# Be a good parent, use ONBUILD

The `**ONBUILD**` instruction is used to specify commands that should be run when a Docker image built from your image is used as the base image for another image. The ONBUILD commands are triggered when a new image is built from your image (after the parent Dockerfile build completes), allowing you to automate tasks such as copying files and setting environment variables.

It is recommended to use another tag (eg: myapp:1.2-onbuild) to prevent failure if the new build’s context is missing the resource being added (using ADD/COPY instructions) and let the choice to the author.

_More info:_ [_https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#onbuild_](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#onbuild)

# Change your USER

By default, containers run as root, but you can use the `**USER**` instruction to specify a different user for your containers to run as. This can help increase security, as running containers as non-root users can reduce the potential impact of security vulnerabilities.

FROM alpine:latest  
  
# Create a new user and switch to that user  
RUN adduser -D -u 1000 appuser  
USER appuser  
  
# Set the working directory to /app  
WORKDIR /app  
  
# Copy the script to the container and make it executable  
COPY script.sh .  
RUN chmod +x script.sh  
  
# Run the script  
CMD ["./script.sh"]

_More info:_ [_https://docs.docker.com/engine/reference/builder/#user_](https://docs.docker.com/engine/reference/builder/#user)

# Check your container’s health

Health checks are a way for Docker to monitor the health of a container. The `**HEALTHCHECK**` instruction is used to specify the command that Docker should use to check the health of the container. Health checks can be used to detect if a container has failed, and Docker can be configured to automatically restart failed containers.

...  
# Set the command to start the web server  
CMD ["python", "app.py"]  
# Add a healthcheck for the web server  
HEALTHCHECK --interval=5s \\  
            --timeout=5s \\  
            CMD curl --fail <http://localhost:5000/health> || exit 1

The `**HEALTHCHECK**` instruction verifies that the python webserver is running correctly. It runs the check every 5 seconds (--interval=5s) and we want to give it a maximum of 5 seconds to respond (--timeout=5s). The CMD instruction specifies the command that will be run to check the health of the container, which in this case is a curl command that tries to connect to the web server's /health endpoint. If the endpoint doesn't respond within the timeout period, or if it returns an error code, the health check will fail and the container will be marked as unhealthy.

_More info:_ [_https://docs.docker.com/engine/reference/builder/#healthcheck_](https://docs.docker.com/engine/reference/builder/#healthcheck)

# Using Shell Form

Shell form: In addition to the exec form, Dockerfiles also support a shell form for commands, which allows you to use shell-specific features, such as environment variable substitution and command chaining. The shell form is specified by including the command in a shell script, such as `SHELL ["/bin/bash", "-c"]`.

_More info:_ [_https://docs.docker.com/engine/reference/builder/#run_](https://docs.docker.com/engine/reference/builder/#run)

# Metadata instructions

Instructions like `EXPOSE` and `LABEL` that will make your life and the lives of the people working with your images easier.

If your container exposes a port, be explicit about it and specify what it exposes using `EXPOSE` instructions. Remember that this instruction doesn’t have any networking impact. It is just metadata.

**LABEL** Labels can be used for a variety of purposes, such as identifying the purpose of the image, the author, and more. Labels can be queried using the `**docker inspect**` command.
```docker
FROM ubuntu:latest  
LABEL maintainer="Your Name <youremail@example.com>"  
LABEL description="This is a simple Dockerfile example that uses the LABEL and EXPOSE instructions."  
RUN apt-get update && \\  
    apt-get install -y nginx  
EXPOSE 80  
CMD ["nginx", "-g", "daemon off;"]
```
# Dockerfile when built, is only a tar

Did you know that a Docker image is actually just a tar file? That’s right — all those fancy Docker images you’ve been creating and running are really just compressed archives of files and directories

When you build a Docker image, Docker takes all the files and directories you specify in your Dockerfile, compresses them into a single tar file, and then adds some metadata on top.

This compressed tar file is what gets pushed to a Docker registry and then pulled down by other users or machines when they want to run the image. This way, your image can be stored in an object stored (S3-like) as tar, but that’s not a good practice! :)