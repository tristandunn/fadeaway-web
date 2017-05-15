require "administrate/base_dashboard"

class CrashDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    user:       Field::BelongsTo,
    id:         Field::Number,
    version:    Field::String,
    system:     Field::Text,
    created_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :user,
    :version,
    :system,
    :created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :id,
    :version,
    :system,
    :created_at
  ].freeze

  FORM_ATTRIBUTES = [].freeze
end
