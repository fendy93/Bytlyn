json.array!(@deliveries) do |delivery|
  json.extract! delivery, :id, :phone, :rest_id, :version, :user_id, :address, :total
  json.url delivery_url(delivery, format: :json)
end
