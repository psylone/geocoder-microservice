channel = RabbitMq.consumer_channel
queue = channel.queue('geocoding', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  # coordinates = Geocoder.geocode(payload)

  # if coordinates.present?
  #   client = AdsService::Client.new
  #   client.update_ad(id: nil, lat: lat, lon: lon)
  # end

  channel.ack(delivery_info.delivery_tag)
end
