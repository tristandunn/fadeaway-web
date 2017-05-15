class User < ActiveRecord::Base
  has_many :orders

  validates :name,      presence: true
  validates :remote_id, presence:     true,
                        uniqueness:   true,
                        numericality: { only_integer: true }

  def ordered?
    orders.purchased.count > 0
  end
end
