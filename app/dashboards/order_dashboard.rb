require "administrate/base_dashboard"

class OrderDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    discount:   Field::BelongsTo,
    user:       Field::BelongsTo,
    refunds:    Field::HasMany,
    id:         Field::Number,
    remote_id:  Field::String,
    email:      Field::String,
    amount:     Field::Number.with_options(
      decimals:   2,
      multiplier: 0.01,
      prefix:     "$"
    ),
    status:     Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :user,
    :id,
    :email,
    :amount,
    :status,
    :created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :discount,
    :refunds,
    :id,
    :email,
    :remote_id,
    :amount,
    :status,
    :created_at,
    :updated_at
  ].freeze

  FORM_ATTRIBUTES = [].freeze
end
