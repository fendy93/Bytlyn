json.array!(@versions) do |version|
  json.extract! version, :id, :cust_id, :rest_id, :count
  json.url version_url(version, format: :json)
end
