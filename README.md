# Bypass

It bypasses RabbitMQ messages from a source to a destination queue.

## Env variables

1. `APP_MIN_DURATION_IN_MILLISECONDS` (default: `0`): Average process duration in milliseconds.
1. `APP_MAX_DURATION_IN_MILLISECONDS`(default: `1000`): Maximum variation in milliseconds for process duration.
1. `APP_ERROR_RATE` (default: `0`): Message processor error rate in %. It must be between `0.0` and `1.0`.
1. `RABBITMQ_SOURCE_QUEUE_NAME`: RabbitMQ source queue name.
1. `RABBITMQ_DESTINATION_QUEUE_NAME`: RabbitMQ destination queue name.
1. `RABBITMQ_HOST` (default: `localhost`): RabbitMQ host.
1. `RABBITMQ_PORT` (default: `5672`): RabbitMQ port.
1. `RABBITMQ_USER` (default: `guest`): RabbitMQ username.
1. `RABBITMQ_PASS` (default: `guest`): RabbitMQ password.
