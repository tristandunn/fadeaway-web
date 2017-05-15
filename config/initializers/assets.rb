# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Precompile additional assets.
Rails.application.config.assets.precompile += [
  "homepage.js",
  "order.js",
  "order/index.css",
  "order/show.css",
  "order/new.css",
  "pages/index.css",
  "pages/privacy.css"
]
