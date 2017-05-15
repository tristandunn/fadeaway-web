module CurrentDiscount
  def current_discount
    @current_discount ||= (discount_from_session || discount_from_source)
  end

  def current_discount=(discount)
    @current_discount     = discount.is_a?(Discount) ? discount    : nil
    session[:discount_id] = discount.is_a?(Discount) ? discount.id : nil
  end

  def discount_from_session
    return unless session[:discount_id]

    self.current_discount = Discount.find_by(id: session[:discount_id])
  end

  def discount_from_source
    source = params[:utm_source] || params[:ref]

    return unless source.present?

    self.current_discount = Discount.from_source(source)
  end
end
