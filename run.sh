#!/bin/sh
# this file will run all the subsequent shell scripts
# export COMPOSE_PROJECT_NAME=coffee
# echo $COMPOSE_PROJECT_NAME

./network.sh

sleep 5

./startdocker.sh

sleep 5

./deployCC.sh
