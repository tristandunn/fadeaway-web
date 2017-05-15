Webhook.subscribe("charge.refunded") do |_, object|
  order = Order.find_by!(remote_id: object.id)
  scope = Refund.create_with(order: order)

  object.refunds.data.each do |data|
    scope.find_or_create_by!(remote_id: data.id) do |refund|
      refund.amount     = data.amount
      refund.created_at = Time.at(data.created).utc
    end
  end

  if order.refunds.sum(:amount) == order.amount
    order.refunded!
  end
end
