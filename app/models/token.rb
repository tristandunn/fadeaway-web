class Token
  CLIENT_ID = {
    web:     ENV["DRIBBBLE_WEB_ID"].freeze,
    desktop: ENV["DRIBBBLE_DESKTOP_ID"].freeze
  }.freeze
  CLIENT_SCOPE  = "public".freeze
  CLIENT_SECRET = {
    web:     ENV["DRIBBBLE_WEB_SECRET"].freeze,
    desktop: ENV["DRIBBBLE_DESKTOP_SECRET"].freeze
  }.freeze
  CLIENT_OPTIONS = {
    site:          "https://api.dribbble.com".freeze,
    token_url:     "https://dribbble.com/oauth/token".freeze,
    authorize_url: "https://dribbble.com/oauth/authorize".freeze
  }.freeze

  attr_reader :client, :value

  def initialize(type, value)
    @value  = value
    @client = self.class.client(type)
  end

  def self.authorize_url
    client(:web).auth_code.authorize_url(scope: CLIENT_SCOPE)
  end

  def self.client(type)
    OAuth2::Client.new(CLIENT_ID[type], CLIENT_SECRET[type], CLIENT_OPTIONS)
  end

  def self.create_from_code(type, code)
    token = client(type).auth_code.get_token(code).token

    new(type, token)
  end

  def get(path)
    token.get(path).parsed.with_indifferent_access
  end

  def token
    @token ||= OAuth2::AccessToken.new(client, value)
  end
end
