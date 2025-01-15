#! /bin/bash

docker --version
docker-compose --version 
cd ~/app || exit
docker-compose -f docker-compose-pub.yml down 
docker-compose -f docker-compose-pub.yml up -d
docker ps