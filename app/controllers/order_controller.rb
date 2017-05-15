class OrderController < ApplicationController
  before_action :deny_access,  only: [:index, :new, :create]
  before_action :authenticate, only: [:new, :create]

  rescue_from Stripe::StripeError, with: :handle_stripe_error

  def index
    redirect_to(new_order_path) if signed_in?
  end

  def new
    @order = Order.new(discount: current_discount)
  end

  def create
    @order = current_user.orders.build(order_parameters)
    @order.discount = current_discount

    if @order.save_with_charge
      self.current_discount = nil

      redirect_to(dashboard_index_path, flash: { track: true })
    else
      @order.card_token = nil

      render :new
    end
  end

  protected

  def authenticate
    redirect_to(order_index_path) unless signed_in?
  end

  def deny_access
    redirect_to root_path
  end

  def handle_stripe_error(exception)
    redirect_to new_order_path, flash: { error: exception.message }
  end

  def order_parameters
    params.require(:order).permit(:card_token, :email)
  end
end
