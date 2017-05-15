class Refund < ActiveRecord::Base
  belongs_to :order

  validates :remote_id,  presence: true
  validates :amount,     numericality: { greater_than: 0, only_integer: true }
  validates :created_at, presence: true
end
