json.array!(@guests) do |guest|
  json.extract! guest, :name, :lastname, :email, :mobile, :facebook, :twitter, :instagram, :dish, :companion_id
  json.url guest_url(guest, format: :json)
end
