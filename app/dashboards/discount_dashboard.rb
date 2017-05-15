require "administrate/base_dashboard"

class DiscountDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:         Field::Number,
    name:       Field::String,
    amount:     Field::Number.with_options(
      decimals:   2,
      multiplier: 0.01,
      prefix:     "$"
    ),
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :amount,
    :created_at,
    :updated_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :amount,
    :created_at,
    :updated_at
  ].freeze

  FORM_ATTRIBUTES = [
    :name,
    :amount
  ].freeze

  def display_resource(discount)
    discount.name
  end
end
