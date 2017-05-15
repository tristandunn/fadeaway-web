module Authentication
  extend ActiveSupport::Concern

  ADMINISTRATORS = [3290].freeze

  included do
    helper_method :administrator?, :current_user, :signed_in?
  end

  def administrator?
    current_user.try(:remote_id).in?(ADMINISTRATORS)
  end

  def current_user
    @current_user ||= (user_from_session || user_from_token || :false)
  end

  def current_user=(user)
    @current_user     = user.is_a?(User) ? user    : nil
    session[:user_id] = user.is_a?(User) ? user.id : nil
  end

  def signed_in?
    current_user != :false
  end

  def user_from_session
    return unless session[:user_id]

    self.current_user = User.find(session[:user_id])
  end

  def user_from_token
    return unless params[:access_token]

    token = Token.new(:desktop, params[:access_token])
    data  = token.get("/v1/user")

    self.current_user = User.find_by(remote_id: data[:id])
  rescue # rubocop:disable Lint/HandleExceptions
  end
end
