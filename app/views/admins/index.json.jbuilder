json.array!(@admins) do |admin|
  json.extract! admin, :username, :password
  json.url admin_url(admin, format: :json)
end
