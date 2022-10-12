module GeocoderService
  module Api
    def update_coordinates(id, coordinates)
      payload = { id: id, coordinates: coordinates }.to_json
      connection.post('update_coordinates', payload)
    end
  end
end
