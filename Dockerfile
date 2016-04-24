FROM qnib/alpn-rsyslog

## Kibana
WORKDIR /opt/
ENV KIBANA_VER 4.4.1
RUN curl -slf https://download.elastic.co/kibana/kibana/kibana-4.4.1-linux-x86.tar.gz | tar xfz - -C /opt/
RUN curl -s -L -o kibana-${KIBANA_VER}-linux-x64.tar.gz https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VER}-linux-x64.tar.gz && \
    tar xf kibana-${KIBANA_VER}-linux-x64.tar.gz && \
    rm /opt/kibana*.tar.gz
RUN ln -sf /opt/kibana-${KIBANA_VER}-linux-x64 /opt/kibana4
ADD etc/supervisord.d/kibana4.ini /etc/supervisord.d/
ADD etc/consul.d/kibana4.json /etc/consul.d/
# Config kibana
ADD opt/kibana4/config/kibana.yml /opt/kibana4/config/kibana.yml
## Dashboard
ADD opt/qnib/kibana4/bin/restore.sh \
    opt/qnib/kibana4/bin/start.sh \
    /opt/qnib/kibana4/bin/
ADD opt/qnib/kibana4/dumps/ /opt/qnib/kibana4/dumps/
ADD opt/kibana4/bin/kibana /opt/kibana4/bin/
RUN apk add --update jq bc nodejs nmap \
 && npm install elasticdump -g
ADD etc/supervisord.d/kibana4_restore.ini /etc/supervisord.d/
