class TokensController < ApplicationController
  before_action      :verify
  skip_before_action :verify_authenticity_token

  rescue_from OAuth2::Error, with: :render_error

  def create
    render text: token.value
  end

  protected

  def render_error(error)
    render text: error.description, status: :unauthorized
  end

  def token
    @token ||= Token.create_from_code(:desktop, params.require(:code))
  end

  def verify
    data = token.get("/v1/user")
    user = User.find_by(remote_id: data[:id])

    head(:unauthorized) unless user.try(:ordered?)
  end
end
