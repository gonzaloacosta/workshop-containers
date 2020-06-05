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
