# Bypass

It bypasses RabbitMQ messages from a source to a destination queue.

## Env variables

### Bypass

1. **`RABBITMQ_SOURCE_QUEUE_NAME`**: RabbitMQ source queue name.
1. **`RABBITMQ_DESTINATION_QUEUE_NAME`**: RabbitMQ destination queue name.
1. `RABBITMQ_HOST` (default: `localhost`): RabbitMQ host.
1. `RABBITMQ_PORT` (default: `5672`): RabbitMQ port.
1. `RABBITMQ_USER` (default: `guest`): RabbitMQ username.
1. `RABBITMQ_PASS` (default: `guest`): RabbitMQ password.
1. `APP_MIN_DURATION_IN_MILLISECONDS` (default: `0`): Minimum message processing duration in milliseconds.
1. `APP_MAX_DURATION_IN_MILLISECONDS`(default: `1000`): Maximum message processing duration in milliseconds.
1. `APP_ERROR_RATE` (default: `0.1`): Message processing error rate in %. It must be between `0.0` and `1.0`.

## Build

```sh
docker build . -t bypass
```

## Run

```sh
docker run \
 -e RABBITMQ_SOURCE_QUEUE_NAME="spam" \
 -e RABBITMQ_DESTINATION_QUEUE_NAME="egg" \
 -e RABBITMQ_HOST="localhost" \
 -e RABBITMQ_PORT="5672" \
 -e RABBITMQ_USER="guest" \
 -e RABBITMQ_PASS="guest" \
 -e APP_MIN_DURATION_IN_MILLISECONDS="0" \
 -e APP_MAX_DURATION_IN_MILLISECOND="1000" \
 -e APP_ERROR_RATE="0" \
 bypass
```

Make sure to use the `--net=host` option if RabbitMQ is running in the host network.
