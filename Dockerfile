FROM qnib/alpn-rsyslog

## Kibana
WORKDIR /opt/
ADD etc/supervisord.d/kibana4.ini /etc/supervisord.d/
ADD etc/consul.d/kibana4.json /etc/consul.d/
## elasticdump
RUN apk add --update jq bc nodejs nmap \
 && npm install elasticdump -g
ADD etc/supervisord.d/kibana4_restore.ini /etc/supervisord.d/
ENV KIBANA_VER 4.1.8
RUN curl -slf https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VER}-linux-x64.tar.gz |tar xfz - -C /opt/ \
 && ln -sf /opt/kibana-${KIBANA_VER}-linux-x64 /opt/kibana4 \
 && rm -f /opt/kibana4/node/bin/node \
 && ln -s /usr/bin/node /opt/kibana4/node/bin/node
# Config kibana
ADD opt/kibana4/config/kibana.yml /opt/kibana4/config/kibana.yml
## Dashboard
ADD opt/qnib/kibana4/bin/restore.sh \
    opt/qnib/kibana4/bin/backup.sh \
    opt/qnib/kibana4/bin/start.sh \
    /opt/qnib/kibana4/bin/
ADD opt/qnib/kibana4/dumps/ /opt/qnib/kibana4/dumps/
#ADD etc/supervisord.d/kibana4_restore.ini /etc/supervisord.d/
#RUN npm install -g n \
#  && n stable \
#  && npm install elasticdump -g
