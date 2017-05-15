class PagesController < ApplicationController
  before_action :build_order, only: [:index, :sketch]

  def index
    @discount = @order.discount
  end

  def sketch
    @release = Release.latest
  end

  private

  def build_order
    @order = Order.new(discount: current_discount)
  end
end
