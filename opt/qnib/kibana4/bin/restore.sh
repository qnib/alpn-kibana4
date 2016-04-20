#!/bin/bash

source /opt/qnib/consul/etc/bash_functions.sh
ES_HOST=${ES_HOST-elasticsearch.service.consul}
cnt=0

wait_for_srv elasticsearch

kibana_size=$(curl -s http://${ES_HOST}:9200/.kibana/_status|jq '.indices[".kibana"].index.size_in_bytes')

if [ "Xnull" == "X$kibana_size" ];then

    if [ -f /opt/qnib/kibana4/dumps/mapping.json ];then
         elasticdump \
             --type=mapping \
             --input=/opt/qnib/kibana4/dumps/mapping.json \
             --output=http://${ES_HOST}:9200/.kibana
    fi

    if [ -f /opt/qnib/kibana4/dumps/data.json ];then
         elasticdump \
             --type=data \
             --input=/opt/qnib/kibana4/dumps/data.json \
             --output=http://${ES_HOST}:9200/.kibana
    fi
fi

exit 0
