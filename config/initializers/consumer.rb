channel = RabbitMq.consumer_channel
queue = channel.queue('geocoding', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON(payload)
  p "payload: #{payload}"
  coordinates = Geocoder.geocode(payload['city'])
  p "coordinates: #{coordinates}"

  if coordinates.present?
    client = GeocoderService::Client.new
    client.update_coordinates(payload['id'], coordinates)
  end

  channel.ack(delivery_info.delivery_tag)
end
