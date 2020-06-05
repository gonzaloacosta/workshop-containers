## Demo podman
1. [Administracion de contenedores](#1.0)
    1. [Podman install](#1.1)
    2. [Images Container](#1.2)
    3. [Running Containers](#1.3)
    4. [Crear Service DB y HTTP](#1.4)
    5. [Container Storage](#1.5)
    5. [Dockerfiles](#1.6)

## 1 Ejercicios Dia 1 <a name="1.0"></a>
Texto texto texto

### 1.1 Podman install

```
sudo yum -y install podman
```

### 1.2 Images Container

Buscamos imagenes
```
sudo podman search rhel
```

Sintaxis de imagen
```
<registry_name>/<user_name?>/<image_name>:<tag_name>
```

Descarmamos imagen de manera local
```
sudo podman pull rhel
```

Listamos las imagenes descargadas
```
sudo podman images
```

### 1.3 Running container

Ejecutamos un comando dentro de un contenedor
```
sudo podman run rhel echo "Hola Mundo!"
```

Ejecutamos un servicio dentro de un contenedor
```
sudo podman run -d rhscl/httpd-24-rhel7
```

Inspeccionamos la configuracion de un contenedor
```
sudo podman inspect -l -f "{{.NetworkSettings.IPAddress}}"
```

Terminal en un pod
```
-i interact
-t tty
```
```
sudo podman run -it rhel7 /bin/bash
```

Variables de entorno en el momento de la ejecucion
```
sudo podman run -e HELLO=hola -e NAME=gonzalo rhel printenv HELLO NAME
```

Otro ejemplo lanzando una base de datos MYSQL
```
sudo podman run --name mysql -e MYSQL_USER=user -e MYSQL_PASSWORD=pass1 -d mysql:5.5
```

Listamos y borramos todos los contenedores que quedaron stopeados
```
for i in $(sudo podman ps -a | grep -v CONTAINER | awk '{print $1}') ; do sudo podman stop $i ; sudo podman rm $i ; done
```

### 1.4 Creamos una aplicacion

Creamos una base de datos mysql
```
sudo podman run --name mysql-small \
    --e MYSQL_USER=user1 \
    -e MYSQL_PASSWORD=pass1 \
    -e MYSQL_DATABASE=stock \
    -e MYSQL_ROOT_PASSWORD=root123 -d \
    rhscl/mysql-57-rhel7
```

Chequeamos que el contenedor este corriendo
```
sudo podman ps -a
```

Ejecutamos un comando dentro del contenedor para ver la base de datos creada
```
sudo podman exec -it mysql-small /bin/bash
```

Revisamos la base de datos
```
[gonza@centos ~]$ sudo podman exec -it mysql-small /bin/bash
bash-4.2$ mysql -uroot
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.24 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| stock              |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

mysql> use stock;
Database changed
mysql> CREATE TABLE inventory (id int(11) NOT NULL, name varchar(255), quantity int(11), PRIMARY KEY (id));                                                                                  Query OK, 0 rows affected (0.02 sec)

mysql> show tables;
+-----------------+
| Tables_in_stock |
+-----------------+
| inventory       |
+-----------------+
1 row in set (0.00 sec)

mysql> insert into inventory (id, name, quantity) values (1,
    -> 'facturas', 12);
Query OK, 1 row affected (0.02 sec)
mysql> select * from inventory;
+----+----------+----------+
| id | name     | quantity |
+----+----------+----------+
|  1 | facturas |       12 |
+----+----------+----------+
1 row in set (0.00 sec)

mysql> exit
```

Ejecutamos un servidor web en el puerto 8080
```
 -p <host port>:<container port>
```

```
sudo podman run -d -p 8080:8080 --name httpd-small httpd:2.4
```

Chequemos que el contenedor este corriendo
```
sudo podman ps -a
```

> Nota: la columna PORT debe tener el detalle del puerto.

> Debe abrir los puertos en el host donde corre el contenedor en caso de que tenga un firwall local corriendo. 
```
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

Probamos la aplicacion
```
curl http://localhost:8080
```

Creamos un index para identificar nuestra pagina
```
sudo podman exec -it httpd-small /bin/bash
curl http://localhost:8080/
Hola Mundo!!!!
```

## 1.5 Container Storage

Creamos un directorio donde vamos a persistir informacion
```
sudo mkdir /var/db
```

En el caso de MySQL tomado del repositorio de Red Hat el contenedor corre con el UID 27.
```
sudo chown -R 27:27 /var/db
```

Aplicamos el contexto de SELinux al directorio 
```
semanage fcontext -a -t container_file_t '/var/db(/.*)?'
```

Aplicamos SELinux policy
```
restorecon -Rv /var/db
```

Chequemos los permisos.
```
ls -dZ /var/local/mysql
```
Montamos el volumen
```
sudo podman run --name persist-db -d -v /var/db:/var/lib/mysql/data -e MYSQL_USER=user1 -e MYSQL_PASSWORD=pass1 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=toor rhscl/mysql-57-rhel7
```

```
sudo podman ps --format="table {{.ID}} {{.Names}} {{.Status}}
```

## 1.6. Dockerfiles

1. Creamos el directorio de trabajo
```
mkdir $HOME/httpd-small/
cd $HOME/httpd-small/
```

2. Creamos el dockerfile dentro del directorio.
```
cat < EOF > Dockerfile
# Comentario con instrucciones
FROM centos
MAINTAINER Gonzalo Acosta <gonzalo.acosta@semperti.com>
ENV PORT 8080
RUN yum -y install httpd && \
    yum clean all
RUN sed -ri -e "/^Listen 80/c\Listen ${PORT}" /etc/httpd/conf/httpd.conf && \
    chown -R apache:apache /etc/httpd/logs/ && \
    chown -R apache:apache /run/httpd/
USER apache
EXPOSE ${PORT}
ADD about.html /var/www/html/
CMD ["httpd", "-D", "FOREGROUND"]
EOF
```

3. Build de la imagen.
```
sudo podman build -t httpd-small:lates .
```

4. Test
```
$ curl http://localhost:8080/about.html
About me!
```


### [Footnotes](https://semperti.com)

Autor: Gonzalo Acosta
email: gonzalo.acosta@semperti.com







