Openshift Workshop Administracion 
=================================

Workshop de adminsitracion de Openshift de 0 a 100 en 5 dias.

# Tabla de Contenido
1. [Tecnologia de Contenedores](#1.1)
2. [Arquitectura de Contenedores](#1.2)
3. [Kubernetes and Openshift](#1.3).
4. [Demo - Deploy Apps con Podman](#1.4)
5. [Container Lifecycle con Podman](#1.5)
6. [Persistent Storage](#1.6)
7. [Networking](#1.7)
8. [Images and Registries](#1.8)
9. [Dockerfile - Custom Images](#1.9)


## Deploy de Labs Workshop Frontend <a name="1.0"></a>

```
oc new-app osevg/workshopper:latest --name=workshop-containers \
        -e CONTENT_URL_PREFIX=https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master \
        -e WORKSHOPS_URLS=https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_worshop.yml
oc expose svc/workshop-containers
```
### [Footnotes](https://semperti.com)

Autor: Gonzalo Acosta
email: gonzalo.acosta@semperti.com
