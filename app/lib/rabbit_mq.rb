module RabbitMq
  class NotInitializedError < StandardError
    MSG = 'RabbitMq was not initialized. Call RabbitMq.initialize! before accessing the RabbitMq connection'.freeze

    def initialize(msg = MSG)
      super
    end
  end

  extend self

  def initialize!
    @connection = Bunny.new.start
  end

  def connection
    @connection || raise(NotInitializedError)
  end

  def channel
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  def consumer_channel
    # See http://rubybunny.info/articles/concurrency.html#consumer_work_pools
    Thread.current[:rabbitmq_consumer_channel] ||=
      connection.create_channel(
        nil,
        Settings.rabbitmq.consumer_pool
      )
  end
end
