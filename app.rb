require 'json'
require 'bunny'

class App
  MIN_DURATION = ENV.fetch('APP_MIN_DURATION_IN_MILLISECONDS', 0).to_i
  MAX_DURATION = ENV.fetch('APP_MAX_DURATION_IN_MILLISECONDS', 1000).to_i
  ERROR_RATE = ENV.fetch('APP_ERROR_RATE', 0).to_f

  def initialize(logger)
    @logger = logger
    @source_queue_name = ENV['RABBITMQ_SOURCE_QUEUE_NAME']
    @destination_queue_name = ENV['RABBITMQ_DESTINATION_QUEUE_NAME']

    init_rabbitmq()
    start_fetching_messages()
  end

  private

  def process_message(msg)
    elapsed_time = simulate_slow_process()

    if random_error()
      @logger.info('Oops, some error occurred! Sending message back to source queue')
      send_to_queue(msg.to_json, @source_queue_name)
    else
      msg["from_#{@source_queue_name}_to_#{@destination_queue_name}"] = elapsed_time
      send_to_queue(msg.to_json, @destination_queue_name)
      @logger.info("Message processed in #{elapsed_time.round(1)} milliseconds")
    end
  end

  def start_fetching_messages()
    @logger.info('[*] Awaiting for messages')  
    loop do
      @source_queue.get() do |delivery_info, _properties, body|
        sleep(1) and next if delivery_info.nil?
        process_message(JSON.parse(body))
      end
    end
  rescue Interrupt => _
    @logger.info('Finishing application')
    @connection.close
    exit(0)
  end

  def simulate_slow_process
    total_duration = rand(MIN_DURATION..MAX_DURATION)

    started_at = Time.now()
    sleep(total_duration / 1000.0)
    finished_at = Time.now()

    # elapsed time in milliseconds
    (finished_at - started_at) * 1000
  end

  def random_error
    rand(1..100) < ERROR_RATE * 100
  end

  def send_to_queue(msg, queue_name)
    @channel.default_exchange.publish(msg, routing_key: queue_name)
  end

  def init_rabbitmq
    @connection = Bunny.new(
      host: ENV.fetch('RABBITMQ_HOST', 'localhost'),
      port: ENV.fetch('RABBITMQ_PORT', '5672'),
      user: ENV.fetch('RABBITMQ_USER', 'guest'),
      pass: ENV.fetch('RABBITMQ_PASS', 'guest'),
    )
    @connection.start
    @channel = @connection.create_channel

    @source_queue = @channel.queue(@source_queue_name, durable: true)
  end
end

App.new(Logger.new(STDOUT))
