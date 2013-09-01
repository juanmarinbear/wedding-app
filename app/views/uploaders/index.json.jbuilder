json.array!(@uploaders) do |uploader|
  json.extract! uploader, :name, :lastname, :email
  json.url uploader_url(uploader, format: :json)
end
