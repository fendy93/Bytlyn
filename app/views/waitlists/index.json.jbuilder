json.array!(@waitlists) do |waitlist|
  json.extract! waitlist, :id, :cust_id, :rest_id, :people
  json.url waitlist_url(waitlist, format: :json)
end
