# A Collection of Docker Images To Solve All Your Debugging Needs

MARTIN

Sep 5, 2023

[Kubernetes](https://martinheinz.dev/tag/kubernetes/)[DevOps](https://martinheinz.dev/tag/devops/)

Whenever I troubleshoot anything container-related, I look for a good container image that contains all the right tools to troubleshoot and/or solve the problem. However, finding such an image, or assembling my own is time-consuming and honestly just way too much effort.

So, to save both you and me the hassle of finding or building such image(s), here's a list of container images that will satisfy all the troubleshooting needs.

## The Images

While building a _"swiss army knife container image"_ might seem like a good idea, there are always more things to add and at some point, such image becomes too big and too hard to maintain.

A better option is to use an image such as [`infuser`](https://github.com/teaxyz/infuser). `infuser` is built around `tea` CLI which automatically installs any tool that you invoke. Let's say you run `curl` in a container, but it's not installed. No problem, `tea` will first install it and then invoke your command:

```shell
docker run --rm -it ghcr.io/teaxyz/infuser
...

# curl is not installed...
tea $ curl https://google.com

# installed: ~/.tea/curl.se/ca-certs/v2023.5.30
# installed: ~/.tea/curl.se/v8.2.1
# installed: ~/.tea/openssl.org/v1.1.1u

<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>

# ... but worked anyway!
tea $
```

If you'd rather have an image with everything pre-installed, yet you're too lazy to write a `Dockerfile` and build the image, then you can use `apko.kontain.me` registry. This registry allows you to build an image with specified set of packages simply by pulling it:

```shell
docker run -it --rm apko.kontain.me/busybox/curl

Unable to find image 'apko.kontain.me/busybox/curl' locally
latest: Pulling from busybox/curl
d057dc95df58: Pull complete
Digest: sha256:48ac8175f9551bc96f7229d6c91e163d2b5948b2e80cb26ee8c95e68071ddbe1
Status: Downloaded newer image for apko.kontain.me/busybox/curl:latest

3add74404ade:/# curl
curl: try 'curl --help' for more information
```

When you pull from this registry, each component of the URL is interpreted as a package that will be added to the image (`apko.kontain.me/[package]/[package]/...`), so all you need to do is make list of packages and pull.

Alternatively, if you're a fan of _Nix_, you can do the same with `nixery.dev` registry:

```shell
docker run -it --rm nixery.dev/shell/curl bash

Unable to find image 'nixery.dev/shell/curl:latest' locally
latest: Pulling from shell/curl
bf36edf1bbb6: Pull complete
...
bf30a3da102a: Pull complete
Digest: sha256:d99f1b56330831ee4217e7eb403bc667279f55f28660ef686daff653ac1a6561
Status: Downloaded newer image for nixery.dev/shell/curl:latest

bash-5.2# curl
curl: try 'curl --help' for more information
```

As for more specialized tools, if I need to troubleshoot anything network-related, I always reach for `netshoot`. It contains all the networking tools you might need, all you need to do is run:

```shell
docker run --rm -it nicolaka/netshoot
# OR
kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot
```

The above images should satisfy your troubleshooting needs, but there are a couple honorable mentions:

- [`alpine-containertools`](https://github.com/raesene/alpine-containertools) - Image with common container tooling. Targeted at security assessment tools.
- [Koolkits](https://github.com/lightrun-platform/koolkits#readme) - Language-specific container images that contain a (highly-opinionated) set of tools for debugging applications running in Kubernetes pods. Intended for use with `kubectl debug`.
- [`doks-debug`](https://github.com/digitalocean/doks-debug) or _Digital Ocean Kubernetes Service_ debug image, intended for debugging Kubernetes cluster. Contains lots of useful tools for debugging clusters not only in Digital Ocean.
- ["Utils" image](https://github.com/arunvelsriram/utils) with different set of tools, this one includes various database clients and MQ tools.

## Getting The Most Out of Them

I've shown you a list of images for debugging, but there are couple extra tricks you can use to get the most out of them.

Let's say you need to debug one particular Kubernetes node. You could write a Pod YAML definition and specify `nodeSelector` to get the debug Pod to run on the specific node, but that's way too much effort. Instead, you can run:

```shell
kubectl run debug --rm -i --tty \
  --image=... \
  --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "some-node"}}}' -- bash
```

Alternatively, you can use `kubectl debug`, which is quite literally SSH into a node:

```shell
kubectl debug node/some-node -it --image=...
```

You can obviously utilize `--overrides` flag for other things, e.g. to specify pull secret to test whether credentials are valid:

```shell
kubectl run pull-test --rm -i --tty  \
  --image=... \
  --image-pull-policy="Always" \
  --overrides='{ "spec": { "template": { "spec": { "imagePullSecrets": [{"name": "some-pull-secret"}]}}}}'
```

Above-mentioned `kubectl debug` can also be used for debugging existing Pods:

```shell
# Create an example Pod:
kubectl run nginx --image=nginx --command -- sleep 1000
# Attach ephemeral debug container to it:
kubectl debug --target nginx --image=... -i nginx
# Targeting container "nginx". ...
# Defaulting debug container name to debugger-5dmp2.
# ...
```

There are many more things you can do with `kubectl debug`, I recommend you check out the [docs](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container). You can also take a look at my older article on the topic: _[The Easiest Way to Debug Kubernetes Workloads](https://martinheinz.dev/blog/49)_.

## Finding More

If the above-mentioned tools aren't what you're looking for, then here are couple more places where look for more images.

Official Kubernetes registry hosts a lot of useful images which might be useful when troubleshooting. All the images are available in [GCP console](https://console.cloud.google.com/gcr/images/k8s-artifacts-prod). There you can find things like `kustomize` [image](https://console.cloud.google.com/gcr/images/k8s-artifacts-prod/eu/kustomize/kustomize) or `etcd`-related [images](https://console.cloud.google.com/gcr/images/k8s-artifacts-prod/eu/etcdadm).

Alternatively, all of these images are also listed in [GitHub](https://github.com/kubernetes/k8s.io/tree/main/registry.k8s.io/images) where each directory contains `images.yaml` which lists image names and tags. For example `k8s-staging-etcdadm` directory lists the above-mentioned `etcd` images for `etcd-backup`, `etcd-dump` and `etcd-manager`.

If you're more of a commandline person, then you can also explore registries with [`crane` tool](https://github.com/google/go-containerregistry/tree/main/cmd/crane). Here, to list tags of particular image:

```shell
docker run --rm gcr.io/go-containerregistry/crane ls eu.gcr.io/k8s-artifacts-prod/kustomize/kustomize

sha256-05e12a3e5085902d3d1b99a0ce74d7d9cead0d8a0343df7f306db7b1616a27b5.sig
...
v3.10.0
v3.8.10
v3.8.7
...
```

Or to list images for the whole registry:

```shell
docker run --rm -it --entrypoint "/busybox/sh" gcr.io/go-containerregistry/crane:debug

crane auth login -u <USERNAME> -p <PASSWORD> <SOME_REGISTRY>
# 2023/07/28 09:14:19 logged in via /root/.docker/config.json
crane catalog <SOME_REGISTRY>
# ...
```

Nowadays, many production-grade images ship with just the bare minimum needed to run the application, which is great for security, but not great for debugging. These images however, usually have a debug version with a `:debug` tag which includes more tools.

Finally, sometimes you just need a single specialized CLI tool e.g. to connect to database or troubleshoot particular service. More often than not, these CLI tools ship with the image for the service itself. So, if you e.g. need `psql` to connect to PostgreSQL database, then just use official `postgres` image. Same goes for `redis-cli` and `redis`, `mongoexport` and `mongo` image, etc.

The easiest way to find the relevant image is in this case to search _"official"_ or _"verified"_ [images on Docker Hub](https://hub.docker.com/search?image_filter=official&q=).

## Closing Thoughts

Nowadays, when I need to debug something I usually just reverse-search shell history for one of the invocations of earlier shown commands/images (CTRL+R + `apko`/`netshoot`/`kubectl debug`), which saves a lot of time, and hopefully some of these images and commands will save you time as well!

And while this article focused on debugging, I'm convinced that anything - not just debugging - can be solved with `docker pull` and when I say _anything_ I really mean it. Rather than installing a million tools and applications, you can just run them with:

```shell
alias curl="docker run --rm -it curlimages/curl:7.83.1"
curl --help
# Usage: curl [options...] <url>
# ...
```