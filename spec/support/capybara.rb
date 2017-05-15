require "capybara/poltergeist"
require "billy/capybara/rspec"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    url_whitelist:     [Token.authorize_url],
    phantomjs_options: [
      "--ignore-ssl-errors=yes",
      "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ]
  )
end

Capybara.javascript_driver = :poltergeist_billy
