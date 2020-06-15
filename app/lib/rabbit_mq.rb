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

  def queue(name, opts = {})
    channel.queue(name, opts)
  end
end
