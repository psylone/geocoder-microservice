require 'securerandom'

module AdsService
  module RpcApi
    def update_coordinates(id, coordinates)
      @lock.synchronize do
        @correlation_id = SecureRandom.uuid
        payload = { id: id, coordinates: coordinates }.to_json

        @queue.publish(
          payload,
          correlation_id: @correlation_id,
          reply_to: @reply_queue.name
        )

        @condition.wait(@lock)
      end
    end
  end
end
