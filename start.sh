#!/bin/sh

# Licensed under the Apache License, Version 2.0
# See accompanying LICENSE file.

# Optional ENV variables:
# * ADVERTISED_HOST: the external ip for the container, e.g. `docker-machine ip \`docker-machine active\``
# * ADVERTISED_PORT: the external port for Kafka, e.g. 9092
# * LOG_RETENTION_HOURS: the minimum age of a log file in hours to be eligible for deletion (default is 168, for 1 week)
# * LOG_RETENTION_BYTES: configure the size at which segments are pruned from the log, (default is 1073741824, for 1GB)
# * NUM_PARTITIONS: configure the default number of log partitions per topic

if [ ! -d "$KAFKA_HOME/bin" ]; then
  echo "FATAL: Kafka is missing. Please re-install."
  exit 1
fi

KAFKA_SERVER_CONF="$KAFKA_HOME"/config/server.properties
ZK_SERVER_CONF="$KAFKA_HOME"/config/zookeeper.properties

# Set the external host and port
if [ ! -z "$ADVERTISED_HOST" ]; then
  echo "advertised host: $ADVERTISED_HOST"
  sed -r -i "s/#(advertised.host.name)=(.*)/\1=$ADVERTISED_HOST/g" "$KAFKA_SERVER_CONF"
fi
if [ ! -z "$ADVERTISED_PORT" ]; then
  echo "advertised port: $ADVERTISED_PORT"
  sed -r -i "s/#(advertised.port)=(.*)/\1=$ADVERTISED_PORT/g" "$KAFKA_SERVER_CONF"
fi

# Allow specification of log retention policies
if [ ! -z "$LOG_RETENTION_HOURS" ]; then
  echo "log retention hours: $LOG_RETENTION_HOURS"
  sed -r -i "s/(log.retention.hours)=(.*)/\1=$LOG_RETENTION_HOURS/g" "$KAFKA_SERVER_CONF"
fi
if [ ! -z "$LOG_RETENTION_BYTES" ]; then
  echo "log retention bytes: $LOG_RETENTION_BYTES"
  sed -r -i "s/#(log.retention.bytes)=(.*)/\1=$LOG_RETENTION_BYTES/g" "$KAFKA_SERVER_CONF"
fi

# Configure the default number of log partitions per topic
if [ ! -z "$NUM_PARTITIONS" ]; then
  echo "default number of partition: $NUM_PARTITIONS"
  sed -r -i "s/(num.partitions)=(.*)/\1=$NUM_PARTITIONS/g" "$KAFKA_SERVER_CONF"
fi

# Run Kafka
"$KAFKA_HOME"/bin/zookeeper-server-start.sh "$ZK_SERVER_CONF" &
"$KAFKA_HOME"/bin/kafka-server-start.sh "$KAFKA_SERVER_CONF"
