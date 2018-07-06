#!/bin/bash

docker stop $(docker ps -a -q)
docker rm -v $(docker ps -aqf status=exited)
docker rmi $(docker images -qf dangling=true)
docker volume rm $(docker volume ls -qf dangling=true)

docker login -u gladiz -p G0dzila0@

usermod -aG vboxsf maximo
usermod -aG vboxsf root

montage="/tmp/docker"
startfolder=`pwd`

#docker run -d --rm --name alfresco  -p 7000:8080 gui81/alfresco
#docker run -d --rm --name jenkins   -p 8000:8080 -p 50000:50000 -v $montage/jenkins:/var/jenkins_home jenkins/jenkins
#docker run -d --rm --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube/sonarqube

docker network create build

git clone http://github.com/gladeroz/maximo-docker.git

mkdir -p /oracle/persistence
chmod -R 777 /oracle

#cd $startfolder/maximo-docker/oracle/SingleInstance/dockerfiles
#oracleFile="oracle-xe-11.2.0-1.0.x86_64.rpm.zip"
#cp /media/sf_JULIEN/sources/oracle/$oracleFile $startfolder/maximo-docker/oracle/SingleInstance/dockerfiles/11.2.0.2/$oracleFile
#sh buildDockerImage.sh -v 11.2.0.2 -x
#docker run --name=oracle --shm-size=1g -p 1521:1521 -p 8080:8080 -e ORACLE_PWD=maximo -v $montage/oracle:/u01/app/oracle/oradata oracle/database:11.2.0.2-xe

cd $startfolder/maximo-docker

docker build -t maximo/db2:10.5.0.9 -t maximo/db2:latest --network build maxdb

docker build -t maximo/maxwas:8.5.5.12 -t maximo/maxwas:latest --network build maxwas

docker build -t maximo/maxdmgr:8.5.5.12 -t maximo/maxdmgr:latest maxdmgr

docker build -t maximo/maxapps:8.5.5.12 -t maximo/maxapps:latest maxapps

docker build -t maximo/maxweb:8.5.5.12 -t maximo/maxweb:latest --network build maxweb

docker build -t maximo/maximo:7.6.0.9 -t maximo/maximo:latest --network build maximo

docker-compose up -d