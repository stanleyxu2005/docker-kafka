# Kafka Mini Cluster with Zookeeper for Testing

The Docker image will create a single node Kafka mini cluster.
* Kafka version: 0.8.2.2
* Scala version: 2.10 

Run with
```
docker run --rm -p 2181:2181 -p 9092:9092 \
  --env ADVERTISE_HOST=your_advertise_host \
  --env ADVERTISE_PORT=your_advertise_port \
  stanleyxu2005/kafka
```
