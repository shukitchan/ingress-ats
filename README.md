ATS Kubernetes Ingress Controller 
=================================
(Deprecated - Please go to https://github.com/apache/trafficserver-ingress-controller)

## Introduction
[Apache Traffic Server (ATS)](https://trafficserver.apache.org/) is a high performance, open-source, caching proxy server that is scalable and configurable. This project uses [Kubernetes ingress controller plugin](https://github.com/torchbox/k8s-ts-ingress) to build a docker image for [Kubernetes(K8s)](https://kubernetes.io/) [ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

## Changes to records.config
- `proxy.config.url_remap.pristine_host_hdr` set to 1
- `proxy.config.http.cache.http` set to 0
- `proxy.config.diags.debug.enabled` set to 1
- `proxy.config.diags.debug.tags` set to `.*kubernetes.*`

