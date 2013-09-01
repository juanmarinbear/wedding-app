json.array!(@images) do |image|
  json.extract! image, :title, :name, :lastname, :email, :url, :approved
  json.url image_url(image, format: :json)
end
