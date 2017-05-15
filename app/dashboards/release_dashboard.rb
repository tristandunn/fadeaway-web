require "administrate/base_dashboard"

class ReleaseDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:          Field::Number,
    logs:        Field::Text,
    version:     Field::String,
    description: Field::Text,
    created_at:  Field::DateTime,
    released_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :version,
    :description,
    :released_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :version,
    :description,
    :created_at,
    :released_at,
    :logs
  ].freeze

  FORM_ATTRIBUTES = [
    :version,
    :description,
    :logs,
    :released_at
  ].freeze

  def display_resource(release)
    release.version
  end
end
