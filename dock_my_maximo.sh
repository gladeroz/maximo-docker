#!/bin/bash

docker stop $(docker ps -a -q)
docker rm -v $(docker ps -aqf status=exited)
docker rmi $(docker images -qf dangling=true)
docker volume rm $(docker volume ls -qf dangling=true)

docker login -u gladiz -p G0dzila0@

usermod -aG vboxsf maximo
usermod -aG vboxsf root

startfolder=`pwd`
hub="http://github.com/gladeroz/maximo-docker.git"

docker network create build

if [ -d maximo-docker ]; then
   rm -rf maximo-docker
fi

git clone $hub

mkdir -p /oracle/persistence
chmod -R 777 /oracle

cd $startfolder/maximo-docker

docker build -t maximo/db2:11.1.3 -t maximo/db2:latest --network build maxdb

#docker build -t maximo/maxwas:9.0.0.7 -t maximo/maxwas:latest --network build maxwas

#docker build -t maximo/maxdmgr:9.0.0.7 -t maximo/maxdmgr:latest maxdmgr

#docker build -t maximo/maxapps:9.0.0.7 -t maximo/maxapps:latest maxapps

#docker build -t maximo/maxweb:9.0.0.7 -t maximo/maxweb:latest --network build maxweb

#docker build -t maximo/maximo:7.6.0.9 -t maximo/maximo:latest --network build maximo

docker-compose up -d