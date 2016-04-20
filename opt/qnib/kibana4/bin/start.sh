#!/bin/bash

source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv elasticsearch

if [ "X${ES_DC}" != "X" ];then
   sed -i'' -e "s#elasticsearch_url:.*#elasticsearch_url: \"http://elasticsearch.service.${ES_DC}.consul:9200\"#" /opt/kibana/config/kibana.yml
fi
if [ "X${ES_URL}" != "X" ];then
   sed -i'' -e "s#elasticsearch_url:.*#elasticsearch_url: \"${ES_URL}\"#" /opt/kibana/config/kibana.yml
fi

/opt/kibana4/bin/kibana --config /opt/kibana4/config/kibana.yml
