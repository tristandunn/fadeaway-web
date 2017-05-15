require "rack/cors"

Rails.application.configure do
  config.middleware.insert_before "ActionDispatch::Static", "Rack::Cors" do
    allow do
      origins  "file://"
      resource "/tokens", methods: [:post]
    end
  end
end
