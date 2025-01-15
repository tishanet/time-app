#! /bin/bash

docker --version
docker-compose --version 

docker-compose -f docker-compose-pub.yml up -d

docker ps 
