class Crash < ActiveRecord::Base
  belongs_to :user

  validates :system,  presence: true
  validates :version, presence: true, format: { with: Version::MATCHER }
end
