# Licensed under the Apache License, Version 2.0
# See accompanying LICENSE file.

# The base image contains JRE8
FROM java:openjdk-8-jre
ENV DEBIAN_FRONTEND noninteractive

# Install needed things
RUN apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Install Kafka and Zookeeper bundle
ENV SCALA_VERSION 2.10
ENV KAFKA_VERSION 0.8.2.2
ENV KAFKA_HOME /opt/kafka
RUN wget -q http://www.us.apache.org/dist/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O kafka.tgz && \ 
    tar -xvf kafka.tgz && rm kafka.tgz && \
    mv kafka_"$SCALA_VERSION"-"$KAFKA_VERSION" "$KAFKA_HOME" && \
    chmod a+x "$KAFKA_HOME"/bin/*.sh
WORKDIR "$KAFKA_HOME"

# Setup the entry point
ADD start.sh /opt/start
RUN chmod +x /opt/start

ENTRYPOINT ["/opt/start"]
