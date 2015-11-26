# Licensed under the Apache License, Version 2.0
# See accompanying LICENSE file.

# The base image contains JRE8
FROM errordeveloper/oracle-jre

# Install Zookeeper and other needed things
RUN opkg-install wget supervisor zookeeper

# Install Kafka
ENV SCALA_VERSION 2.10
ENV KAFKA_VERSION 0.8.2.2
ENV KAFKA_HOME /opt/kafka
RUN wget -q http://www.us.apache.org/dist/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka.tgz && \
    gzip -d /tmp/kafka.tgz && \
    tar xf /tmp/kafka.tar -C /opt && \
    rm /tmp/kafka.* && \
    mv /opt/kafka_* "$KAFKA_HOME"

ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

CMD ["supervisord", "-n"]
