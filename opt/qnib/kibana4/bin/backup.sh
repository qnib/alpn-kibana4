#!/bin/bash

source /opt/qnib/consul/etc/bash_functions.sh
ES_HOST=${ES_HOST-elasticsearch.service.consul}

elasticdump \
    --type=mapping \
    --input=http://${ES_HOST}:9200/.kibana \
    --output=/root/mapping.json 

elasticdump \
    --type=data \
    --input=http://${ES_HOST}:9200/.kibana \
    --output=/root/data.json 

exit 0
