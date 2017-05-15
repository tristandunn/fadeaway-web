require "administrate/base_dashboard"

class RefundDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    order:      Field::BelongsTo,
    id:         Field::Number,
    remote_id:  Field::String,
    amount:     Field::Number.with_options(
      decimals:   2,
      multiplier: 0.01,
      prefix:     "$"
    ),
    created_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :order,
    :id,
    :amount,
    :created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :order,
    :id,
    :remote_id,
    :amount,
    :created_at
  ].freeze

  FORM_ATTRIBUTES = [].freeze
end
