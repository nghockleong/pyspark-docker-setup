#!/bin/bash

SPARK_NODE_TYPE=$1
MASTER_NODE_URL="spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}"

if [ "$SPARK_NODE_TYPE" == "master" ];
then
    start-master.sh
elif [ "$SPARK_NODE_TYPE" == "worker" ];
then
    start-worker.sh $MASTER_NODE_URL
elif [ "$SPARK_NODE_TYPE" == "history" ];
then
    start-history-server.sh
fi