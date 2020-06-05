Openshift Workshop Administracion 
=================================

Workshop de adminsitracion de Openshift de 0 a 100 en 5 dias.

# Tabla de Contenido
1. [Intro](./01_intro.adoc)
2. [Tecnologia de Contenedores](./02_technologies.adoc)
3. [Arquitectura de Contenedores](./03_architecture.adoc)
4. [Kubernetes and Openshift](./orchestration.adoc).
5. [Demo - Deploy Apps con Podman](./demo_deploy.adoc)
6. [Container Lifecycle con Podman](./06_life_cycle_con_podman.adoc)
7. [Persistent Storage](./07_persistent_storage.adoc)
8. [Networking](./08_networking.adoc)
9. [Images and Registries](./09_image_registries.adoc)
10. [Imagenes Custom con Dockerfile](./10_custom_dockerfile.adoc)
11. [Resenas](./11_resena.adoc)



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
