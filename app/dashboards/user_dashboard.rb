require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    orders:     Field::HasMany,
    id:         Field::Number,
    remote_id:  Field::Number,
    name:       Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :remote_id,
    :name,
    :created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :orders,
    :id,
    :remote_id,
    :name,
    :created_at,
    :updated_at
  ].freeze

  FORM_ATTRIBUTES = [].freeze

  def display_resource(user)
    user.name
  end
end
