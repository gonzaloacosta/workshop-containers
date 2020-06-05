Openshift Workshop Administracion 
=================================

Workshop de adminsitracion de Openshift de 0 a 100 en 5 dias.

# Tabla de Contenido

## Dia 1
1. [Introduccion a la tecnologia de contenedores](#1.0)
    1. [Tecnologia de Contenedores](#1.1)
    2. [Arquitectura de Contenedores](#1.2)
    3. [Kubernetes and Openshift](#1.3).
    4. [Demo - Deploy Apps con Podman](#1.4)
    5. [Container Lifecycle con Podman](#1.5)
    6. [Persistent Storage](#1.6)
    7. [Networking](#1.7)
    8. [Images and Registries](#1.8)
    9. [Dockerfile - Custom Images](#1.9)


## 1.1. Introduccion a la tecnologia de contenedores <a name="1.0"></a>

### Objetivo
Poder reconocer las tecnologias que intervienen en el despliegue de aplicaciones basadas en contenedores y la diferencia respecto a los despliegues tradicionales. 

## 1.2. Tecnologia de contenedores <a name="1.1"></a>

De forma habitual las aplicaciones de software dependen de librerias, archivos de configuracion y servicios que son provistos por el ambiente donde corren (environment runtime). La forma tradicional es instalar el environment runtime y todas las dependencias en la maquina virtual o equipo fisico donde va a ser alojada la aplicacion. Por ejemplo, instalar el runtime de python 3.6, pip y todas sus dependencias.

Este metodo trae algunos problemas cuando por ejemplo ser realizan actualizaciones del sistema, cuando son portadas a otras maquinas, o cuando se eliminan dependencias. En el momento de la actualizacion, es probable que la aplicacion deba bajarse para poder proceder. Esto trae bajas de servicio que no son deseadas.

![Containers Technologicy](images/containers-1.png)

Alternativamente las aplicaciones pueden ser desplegadas en contenedores. Un contenedor es un set de uno o mas procesos de manera aislada del resto del sistema. Los contendores proveen los mismo beneficios que las maquinas virtuales como seguridad, storage, networking aislado.

Los contenedores requieren menos recursos de hardware, el tiempo de start y stop es mucho menor. Tambien pueden aislarse a nivel recursos como Memoria y CPU.

Los contenedores no solo ayudan con la eficiencia, elasticidad y reusabilidad, sino que tambien la portabilidad. 

### OCI Specification
Open Container Initiative (OCI) proporciona un conjunto de estándares de la industria que definen dos estandares:

- image-spec: Las especificaciones de imagenes definen como sera el formato del bundle de archivos y metadata que tendra la imagen de un contenedor. 
- runtime-spec: Algunos de los runtime disponibles son containerd, CRI-O, Firecracker, lxd, runc, docker, podman.


### Ventajas del uso de contenedores
- Low hardware footprint
- Environment isolation
- Quick deployment 
- Multiple environment deployment
- Reusability

Por esto mismo son un approcah ideal al pensar aplicaciones con arquitectura de microservicios. Cada servicio es encapsulado en un contenedor.

Reference:
- [opencontainers.org](#https://opencontainers.org/)
- [CNCF Landscape](#https://landscape.cncf.io/category=container-runtime&format=card-mode&grouping=category)


## 1.3. Arquitectura de contendores <a name="1.2"></a>
En el 2001 linux introduce el proyecto de vServers en la comunidad. vServers fue la primer intento de ejecutar un conjunto de procesos dentro de un unico servidor con un alto nivel de aislamiento. Con los vServers la idea de aislar procesos marco el camino para la evolucion de una serie de features del kernel de linux:

- *Namespaces*: El kernel puede aislar recursos especificos de sistemas, usualmente visibles por todos los procesos y colocarlos dentro de un espacio de nombres. Dentro del espacio de nombres solo los procesos que son mienbros pueden ver los recursos. Los espacios de nombre pueden incluir espacios de red, interfaces, process id, puntos de montaje, recursos de IPC y informacion del host de sistem.
- *Control Groups (cgroups)*: Los cgroups imponen restricciones sobre la cantidad de recursos del sistema qeu los procesos podrían usar. Estas restricciones permiten proteger los recursos del sistema.
- *Seccomp*: Seccomp limita como pueden los procesos consumir las system calls. Seccomp define un security profile para procesos. Whitelisling de syscalls, params y file descriptors que son permitidos para usar.
- *SELinux*: SELInux (Security-Enhanged Linux) definen el sistema de control de acceso para procesos. El kernel de linux utiliza SELinux para proteger procesos de otros procesos y tambien limitar el acceso a archivos de sistema del host.

Toda esta serie de caracteristicas de kernel con el fin de poder aislar procesos de sistema y proteger recursos. Ahora bien, desde la perspectiva del kernel, un contenedor es un procesos con restricciones. Sin embargo, en lugar de correr un binario, corre una imagen. La imagen es un bundle de archivos de sistema que contiene toda las dependencias requeridas para ejectuar el proceso.

> Executable files >> Running Process

> Images >> Runnming Containers.

Correr containers a partir de una imagen inmutable brinda la posibilidad de poder reutilizar la misma imagen de manera simultanea para multiples containers. Estas imagenes son bundle de archivos que pueden ser adminsitrador por un sistema de control de version.

Las imagenes de contenedores necesitan ser alojadas de manera local para que el container runtime pueda ejecutar un container. Un repositorio de imagenes es un servicio -publico o privado- donde pueden ser almacenadas para luego ser consumidas.

### Images registry
- Quay.io
- DockerHub
- Google Container Registry
- Amazon Elastic Container Registry.

### Managing Containers with Podman

Podman is una herramienta open source para adminsitrar containers, image containers e interacturar con images registry. 

Ventajas:
- OCI Compliance. Standard, community-driven, non-propietary image format.
- Podman almacena de manera local las imagenes de los contenedores. Evitando architecturas client/server y demonios locales.
- Podman sigue las mismas especificaciones que Docker CLI.
- Podman es compatible con kubernetes y kubernetes puede usar podman para manejear contenedores.

```
sudo yum -y install podman
sudo dnf -y install podman
```
### Referencias
- [podman.io](#https://podman.io)

## 1.4. Kubernetes and Openshift <a name="1.3"></a>

### Limitaciones en el uso de contenedores

Cuando el numero de contenedores administrado por la organizacion crece, el trabajo manual comienza a ser exponencial lo que trae potenciales errores en la administracion. Cuando se utilizan contenedores en produccion las organizaciones requieren:

- Una facil comunicacion entre el gran numero de servicios.
- Limitar recursos de aplicacion, independientemente del numero de contenedores que se ejecuten.
- Responder a los picos de consumo incrementando y decrementando los contenedores que se ejecuten.
- Reaccionar al deterioro de servicio.
- Despliegues de manera gradual sobre los nuevos releases.

### Kubernetes Overview

Kubernetes es un servicio de orquestacion de contenedores que simplifica el despliegue, administracion y escalado de aplicacioens basadas en contenedores.

La unidad mas pequena que es adminsitrada en kubernetes es el pod. Un pod consisten en uno o mas contenedores con su storage e ip que representan a una aplicacion. Kubernetes usa los pods para orquestar los contenedores dentro de el y limitar los recursos en una simple unidad. 

### Kubernetes Features

Kubernetes ofrece las siguientes caracteristicas por sobre el container runtime.

- Service discovery and load balancing.
- Horizontal scaling
- Self-healing
- Automated rollout
- Secrets and configuration management
- Operators

### Openshift Overview

Red Hat Openshift Container Platform (RHOCP) es un conjunto de componentes modulares y servicios sobre Kubernetes. Openshift agrega caracteristicas que transforman a Kubernetes en un PaaS production ready. Openshift ofrece mejores en los siguientes aspectos:

- Routes
- Multitenancy
- Security
- Metrics and Logging.
- Integrated developer workflow.
- Unified UI

## 1.4. DEMO Podman <a name="1.1"></a>

- [Ejercicio 1 - Demo Podman](ejercicios/01/README.md)

## 1.5. Ciclo de vida de contenedores con podman

*Podman managing subcommands*
![Podman managing subcommands](images/podman-1.png)

*Podman query subcommands*
![Podman query subcommands](images/podman-2.png)

### Resumen de comandos para administracion

Crear contenedor
```
sudo podman run rhscl/httpd-24-rhel7
```

Estado de contenedor
```
sudo podman ps -a
```

Comando dentro de contenedor
```
sudo podman exec httpd-small cat /etc/hostname
suod podman exec -l cat /etc/hostname
```

Inspeccionar metadata de contenedor. Output JSON
```
sudo podman inspect httpd-small
```

IPAdress de Contenedor
```
sudo podman inspect -f '{{.NetworkSettings.IPAdrees}}' httpd-small
```

Stop Container
```
sudo podman stop httpd-small
```

Enviar SIGNAL
```
sudo podman kill -s <SIGNAL ID> httpd-small
```

Restart
```
sudo podman restart httpd-small
```

Remover contenedor
```
sudo podman rm httpd-small
```

Remover imagen
```
sudo podman rmi <image id>
```

Logs
```
sudo podman logs httpd-small
```

## 1.6. Persistent Storage <a name="1.6"></a>

Se dice que el storage de los contenedores es efimero, esto significa que el contenido no persiste tras un reinicio. Las aplicaciones en contenedores asumen que el storage sobre el cual trabajan esta vacio, esto permite que los contenedores puedan destruirse y crearse inesperadamente.

Hasta ahora las imagenes de los contenedores se caraterizaban por ser inmutables y por capas, esto significa que no cambian, sino que se componen por layer que anulan el contenido de la capa anterior. 

Un contenedor cuando se ejecuta, crea un nuevo layer sobre la base del original, este layer es el container storage. Este storage es usado para poder crear archivos temporales de lectura y escritura, logs, etc. Estos archivos son considerados efimeros. Ahora bien, un mismo conteiner puede ser detenido (stop) y ejecutado nuevamente (start) y la informacion efimera sigue. No asi si es elimiado (rm). Ahora bien si deseamos lanzar una nueva replica desde la misma imagen esta informacion base sera la misma pero la efimera solo se mantendra con el contenedor que esta corriendo. Podemos hacer la siguiente prueba.

Lanzamos un contenedor 
```
sudo podman run -d --name httpd-1 rhscl/httpd-24-rhel7
sudo podman exec -it httpd-1 /bin/bash
bash-4.2$ echo "Hola httpd-1" > /var/www/html/index.html
```

Podemos ver el archivo en el contenedor
```
bash-4.2$ cat /var/www/html/index.html
Hola httpd-1
bash-4.2$
```

Vemos el archivo efimero que hemos creado
```
ls -ltr $(podman inspect -l -f "{{.GraphDriver.Data.UpperDir}}")/var/www/html/
```

```
[gonza@centos ~]$ sudo su -
Last login: Mon Jun  1 18:21:13 EDT 2020 on pts/5
[root@centos ~]# ls -ltr $(podman inspect httpd-1 -f "{{.GraphDriver.Data.UpperDir}}")/var/www/html/
total 4
-rw-r--r--. 1 1001 root 13 Jun  1 18:51 index.html
[root@centos ~]# logout
[gonza@centos ~]$
```

Pero si lo eliminamos y lo volvemos a crear
```
sudo podman rm httpd-1
sudo podman run -d --name httpd-1 rhscl/httpd-24-rhel7
```
No esta el archivo que habiamos creado
```
[root@centos ~]# ls $(podman inspect httpd-1 -f "{{.GraphDriver.Data.UpperDir}}")/var/
log
[root@centos ~]#
```

Como vemos hasta aqui, el storage efimero no es suficiente para aplicaciones que necesitan persistir datos luego de un reinicio, ej. una base de datos. Para soportar esta necesidad el adminsitrador debe proveer storage persistente.

Persistent Storage
![Persistent Storage](images/storage-1.png)

Los contenedores no deben persistir datos en el espacio efimero, no solo porque no hay un control de cuanto storage alojar sino porque debido a los layers no es performante para aplicaciones de alto io.

### Host Path

Podman puede montar directorios de host dentro del contenedor y fuera del espacio de storage efimero. De modo que los datos que se deseen persistir seran resguardados de manera segura.

Un contenedor se ejecuta como un proceso de sistema operativo, este proceso posee un user id y group id en el host. Los archivos que el utilice deben tener los permisos necesarios para poder ser accedidos. Podman en RHEL utilizar SELinux, `container_file_t`, para proteger el acceso de otros procesos a los archivos del contenedor. Esto evita fuga de inforamcion entre el host y las aplicaciones ejecutando dentro del contenedor.

### [Ejercicio Container Storage 1.6](#ejercicios/01/README.md)


## 1.7. Netwroking <a name="1.7"></a>

### CNI
La `Cloud Native Computing Fundation (CNCF)` sponsorea el proyecto open source `Contianer Network Interfaces (CNI)`. El proyecto tiene como objetivo estandarizar la interfaz de red de los contendores en entornos nativos de nube, como kubernetes y Openshift.

Podman usa CNI para implementar la software-define network (SDN) para contenedores en un host. Podman conecta cada contenedor a un virtual brindge y asigna a cada contenedor una ip privada. La configuracion de CNI esta alojada en /etc/cni/net.d/87-podman-bridge.conflist.

```
[gonza@centos ~]$ cat /etc/cni/net.d/87-podman-bridge.conflist
{
    "cniVersion": "0.4.0",
    "name": "podman",
    "plugins": [
        {
            "type": "bridge",
            "bridge": "cni-podman0",
            "isGateway": true,
            "ipMasq": true,
            "ipam": {
                "type": "host-local",
                "routes": [
                    {
                        "dst": "0.0.0.0/0"
                    }
                ],
                "ranges": [
                    [
                        {
                            "subnet": "10.88.0.0/16",   <<< Subred definda para los pods>>>
                            "gateway": "10.88.0.1"      <<< Gateway definida en la subred>>>
                        }
                    ]
                ]
            }
        },
        {
            "type": "portmap",
            "capabilities": {
                "portMappings": true
            }
        },
        {
            "type": "firewall"
        }
    ]
}
[gonza@centos ~]$
```
Linux Container Network
![networking-1](#images/networking-1.png)

Cuando un pod es creado se le asigna una ip de la red 10.88.0.0/16 en le host, este contenedor pude comunicarse libremente con otros containers por la ip de pods. Esta pequena topologia de red se la llama SDN de host. Los contendores creados con podman en host diferentes no pueden comunicarse entre ellos, las SDN de cada host son indipendientes. Es importante notar que todos los pods estan ocultos de la red del host. La red 10.88.0.0/16 es una red NO RUTEADA.

La ip del pod la podemos ver realizando el inspect.
```
sudo podman inspect -f '{{.NetworkSettings.IPAdrees}}' httpd-small
```

### Port Mapping
Cuando el contenedor se crea, se asigna una ip address del pool de host. Esta estara disponible hasta que el pod muera. Una vez recreado el pod levanta con una nueva ip. Para poder comunicarse con el mundo exterior hay que realizar un `port mapping` o `port fowarding`. 

Con podman realizamos el port forwaring de la siguiente manera `-p [host ip address:][host port]<container port>` con `podman run`.

```
sudo podman run -d -p 8080:8080 --name httpd-small httpd:2.4
```

## 1.8. Image Registries and managing images <a name="1.8"></a>

- Images Registries

Image registries es un servicio que ofrece la descarga de imagenes de contenedores. Estas permiten centralizar el creado y mantenimiento de las imagnes de contendores que en los host donde vamos a ejecutar las aplicaciones van a consultar.

Podman permite buscar entre distintas image registries imagenes para luego ejecutar contenedores. Las registries pueden ser publicas o privadas. Red Hat, como muchos vendors, ofrece un catalogo de imagenes curadas, esto quiere decir:

Red Hat Public Registries
- Fuente confiable
- Dependencias originales
- Libre de vulnerabilidades.
- Runtime protection.
- RHEL Compatible
- RH Support

Private Registries
- Privacidad.
- Restricciones legales.
- Evita publicar imagenes de desarollo.

#### Configuracion de registries con podman

El archivo de configuracion donde se definen las registries es `/etc/containers/registries.conf`

```
[registries.search]
registries = ["registry.redhat.io", "quay.io"]
```

> Encaso de que tengamos que agregar nuevas imagenes, ya sea en un servidor standalone o en kubernetes u openshift, debemos editar este archvio. En el caso de Openshift haremos uso de `Operator` definiendo el `machineconfig`.

En el mismo archivo de configuracion podemos definir registries inseguras. Es util para ambientes de desarrollo.
```
[registries.insecure]
registries = ['localhost:5000]
```

#### Acceder a las registries

Para poder acceder a las registry usamos el comando `podman search` como lo hemos visto en el la primer demo.

```
sudo podman search [option] <term>
```
```
> --limit <number>
> --filter <filter=value>
```

#### Registry Authentication

Algunas registries necesitan autenticacion para poder cosumir imagenes. Podman permite por medio del comando `podman login` poder relizar la authentication.

```shell
sudo podman login -u username -p password registry.connect.redhat.com
```

```curl
curl -u username:password -Ls "https://sso.redhat.com/auth/realms/rhcc/protocol/redhat-docker-v2/auth?service=docker-registry"
```

La salida entrega un token

```
curl -H "Authorization: Bearer eyJh...mgL4 -Ls https://registry.redhat.io/v2/rhscl/mysql-57-rhel7/tags/list | python -mjson.tool
```

#### Pulling Images

Para poder descargar una imagen remota al repositorio local podman ofrece el comando `podman pull`.

```
sudo podman pull [option] [registry:[port]/]name[:tag]
```

```
sudo podman pull quay.io/nginx
```

#### Images Tags

Una imagen puede tener multiples releses. Este mecanismo es utilizado cuando multiples versiones de la misma aplicacion son provisionadas. Podman posee le subcomando `podman tag`

```
sudo podman tag mysql devops/mysql
```

> NOTA: Si no es espeficicado un tag, podman automaticamente agrega el valor `latest`.

#### Push images

Para poder enviar una imagen local a un repositorio externo hacemos uso de `podman push`

```
sudo podman push devops/mysql
```

#### Saving and load images

Las imagenes de contenedores pueden ser portadas en archivos `.tar`. Podman por medio del comando `podman save` nos permite guardar una iamgen

```
sudo podman save -o httpd.tar registry.access.redhat.com/rhscl/httpd-24-rhel7
```

de la misma manera puede importarse una imagen de contenedor en un archivo .tar
```
sudo podman load -i httpd.tar
```

#### Borrar imagenes

Podman guarda todas las imagenes que son descargadas en un repositorio local, es conveniente realizar un limpieza de manera periodica.

```
sudo podman rmi mysql
```

> Nota: hay que evitar utilizar --force, este borra las imagenes incluso si la imagen tiene un layer que esta siendo utilizado por otro contenedor.

Para borrar toda las imagenes
```
sudo podman rmi -a
```
#### Diff respecto al a imagen original

Podemos listar todos los archivos que han sido modificados en un contenedor por medio de `podman diff`
```
[gonza@centos ~]$ sudo podman diff httpd-small
C /etc
C /root
A /root/.bash_history
C /usr/local
C /usr/local/apache2
C /usr/local/apache2/htdocs
C /usr/local/apache2/htdocs/index.html
C /usr/local/apache2/logs
C /usr
A /usr/local/apache2/logs/httpd.pid
[gonza@centos ~]$
```

#### Crear imagenes usando commit

Si bien la mejor manera de poder crear imagenes de contenedores es utilizando dockerfiles, tenemos la opcion podman commit para poder crear una imagen a partir de un contendores que esta siendo ejecutado.

```
sudo podman commit --author "Gonzalo Acosta" --message "primer commit para el workshop" httpd-small httpd-small:latest
```

Esto genera una imagen local con los cambios que habiamos realizado previamente.


## 1.9. Custom Images con Dockerfiles<a name="1.9"></a>

Un Dockerfile es un mecanismo para el creado de imagenes de contenedores automatizado. La contrusccion cuenta con tres pasos bases:

#### 1. Working Directory
Es un directorio de trabajo con todos los archivos necesarios para la construccion de la imagen.

#### 2. Dockerfile
Archivo de texto que contiene todas las instrucciones para construir nuestra imagen. La primer instruccion luego del los comentarios es FROM

```
# Apache custom images
FROM rhel
LABEL description="Imagen custom para workshop"
MAINTAINER Gonzalo Acosta <gonzalo.acosta@semperti.com>
RUN yum -y install httpd
EXPOSE 80
ENV LogLevel "info"
ADD https://gitlab.semperti.com/gonzalo.acosta/workshop-openshift-administration/raw/master/ejercicios/01/index.html /var/www/html/
COPY ./src/about.html /var/www/html/about.html
USER apache
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
```
Algunas consideraciones sobres las instrucciones.

#### ENTRYPOINT and CMD
Hay dos maneras de poder definir estas dos directiva.

- Exec form
```
ENTRYPOINT ["command", "param1", "param2"]
CMD ["param1", "param2"]
```
- Shell form:
```
ENTRYPOINT command param1 param2
CMD param1 param2
```

> Nota: Nunca se debe usar uan combinacion de las dos formas, siempre una u otra.

> Recomendacion: Usar de manera conjunta las dos ENTRYPOINT continuado de CMD, esto permite que cuando hagamos `podman run httpd-small ARG1` el parametro escrito en CMD pueda ser reemplazado con un argumento continuado del `run` donde `ARG1` reemplaza el argument definido en el dockerfile.

#### ADD and COPY
Se pueden definir de la forma Exec como Shell, las dos opciones sirven para poder agregar archivos a la imagen del contenedor. La particularidad de `ADD` es que si manejamos un archivo comprimido/empaquetado es posible desempaquetarlo en destino, `COPY` no permite la descompresion.

> NOTA: Luego de copiar los archivos siempre es recomendable cambiar con `RUN` los permisos copiado con COPY y ADD. Ambos copian archivos reteniendo los permisos, con root como owner.

#### Layers!

Cada instruccion en el Dockerfile crea un layer sobre la nueva imagen. Si tenemos un Dockerfile con muchas instrucciones este tendra una gran cantidad de layers en la imagen resultado. 

Por esto mismo y para tener la menor cantidad de layer en una imagen es recomendable reemplazar estas acciones consecutivas:

```
RUN yum --disablerepo=* --enablerepo="rhel-7-server-rpms"
RUN yum update -y
RUN yum install -y httpd
```

por una sola instruccion que genera un solo layer.
```
RUN yum --disablerepo=* --enablerepo="rhel-7-server-rpms" && \
    yum update -y && \
    yum install -y httpd
```
#### 3. Build Image con podman
Podman posee un subcomando `podman build` para poder hacer el build de las imagenes.

```
sudo podman build -t http-small:latest ./httpd-small
```
### [Ejercicio - Dockerfiles ](#ejercicios/01/README.md)

### [Footnotes](https://semperti.com)

Autor: Gonzalo Acosta
email: gonzalo.acosta@semperti.com
