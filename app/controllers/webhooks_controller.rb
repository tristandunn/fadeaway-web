class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    webhook = Webhook.new(params[:id])
    webhook.instrument

    head :ok
  rescue Stripe::StripeError
    head :bad_request
  end
end
