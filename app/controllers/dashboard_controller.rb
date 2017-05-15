class DashboardController < ApplicationController
  before_action :authenticate
  before_action :verify

  def index
    @release = Release.latest
    @order   = current_user.orders.first if flash[:track]
  end

  protected

  def authenticate
    return if signed_in?

    redirect_to(URI.parse(Token.authorize_url).to_s)
  end

  def verify
    return if current_user.ordered?

    redirect_to(new_order_path)
  end
end
