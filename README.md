Workshop Admistracion de Contenedores con Podman 
================================================

Workshop de adminsitracion de contenedores con Podman 

# Tabla de Contenido
1. [Intro](./01-intro.adoc)
2. [Tecnologia de Contenedores](./02-technologies.adoc)
3. [Arquitectura de Contenedores](./03-architecture.adoc)
4. [Kubernetes and Openshift](./04-orchestration.adoc).
5. [Deploy de aplicaciones con Podman](./05-demo.adoc)
6. [Container Lifecycle con Podman](./06-lifecycle-podman.adoc)
7. [Persistent Storage](./07-persistent-storage.adoc)
8. [Networking](./08-networking.adoc)
9. [Images and Registries](./09-image-registries.adoc)
10. [Imagenes Custom con Dockerfile](./10-custom-dockerfile.adoc)
11. [Resenas](./11-resena.adoc)



## Deploy de Labs Workshop Frontend <a name="1.0"></a>

```
oc new-app osevg/workshopper:latest --name=workshop-containers \
      -e WORKSHOPS_URLS="https://raw.githubusercontent.com/gonzaloacosta/workshop-containers/master/_workshop.yml" \
      -e JAVA_APP=true
oc expose svc/workshop-containers
```

#### Semperti
_Autor_: `Gonzalo Acosta`
_email_: `gonzalo.acosta@semperti.com`
