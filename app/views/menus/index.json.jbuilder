json.array!(@menus) do |menu|
  json.extract! menu, :id, :rest_id, :name, :description, :price
  json.url menu_url(menu, format: :json)
end
