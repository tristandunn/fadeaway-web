module RSpec
  module Helpers
    module API
      JSON_RESPONSE = {
        status:  200,
        headers: {
          "Content-Type" => "application/json"
        }
      }.freeze

      REMOTE_TOKEN_BODY = {
        client_id:     Token::CLIENT_ID[:web],
        client_secret: Token::CLIENT_SECRET[:web],
        grant_type:    "authorization_code"
      }.freeze

      def stub_authorization(user)
        code  = stub_remote_authorization
        token = stub_remote_token(code)

        stub_request(:get, "#{Token::CLIENT_OPTIONS[:site]}/v1/user")
          .with(headers: { "Authorization" => "Bearer #{token}" })
          .to_return(JSON_RESPONSE.merge(body: {
            id: user.remote_id
          }.to_json))
      end

      def stub_authorization_error(error)
        uri    = URI.parse(Token.authorize_url)
        server = Capybara.current_session.server

        proxy
          .stub("https://#{uri.host}:443#{uri.path}")
          .and_return(redirect_to: new_session_url(host:  server.host,
                                                   port:  server.port,
                                                   error: error))
      end

      def stub_remote_authorization
        uri    = URI.parse(Token.authorize_url)
        code   = SecureRandom.hex(32)
        server = Capybara.current_session.server

        proxy
          .stub("https://#{uri.host}:443#{uri.path}")
          .and_return(redirect_to: new_session_url(code: code,
                                                   host: server.host,
                                                   port: server.port))

        code
      end

      def stub_remote_token(code)
        token = SecureRandom.hex(32)

        stub_request(:post, Token::CLIENT_OPTIONS[:token_url])
          .with(body: REMOTE_TOKEN_BODY.merge(code: code))
          .to_return(JSON_RESPONSE.merge(body: {
            scope:        Token::CLIENT_SCOPE,
            token_type:   "bearer",
            access_token: token
          }.to_json))

        token
      end
    end

    RSpec.configure do |config|
      config.include API, type: :feature
    end
  end
end
