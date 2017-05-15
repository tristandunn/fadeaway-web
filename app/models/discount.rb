class Discount < ActiveRecord::Base
  SOURCES = {
    "designernews" => "Designer News",
    "producthunt"  => "Product Hunt"
  }.freeze

  validates :name,   presence: true, uniqueness: { case_sensitive: false }
  validates :amount, numericality: { greater_than: 0, only_integer: true }

  def self.from_source(source)
    find_by(name: SOURCES[source.to_s.downcase])
  end
end
