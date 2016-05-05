json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :event_image, :venue, :location_lati, :location_long, :category, :subcategories, :cost, :date, :time
  json.url event_url(event, format: :json)
end
