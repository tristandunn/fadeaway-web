class Order < ActiveRecord::Base
  DEFAULT_PRICE = 20_00

  belongs_to :discount
  belongs_to :user

  has_many :refunds

  enum status: {
    purchased: 0,
    refunded:  1
  }

  validates :amount,  numericality: { allow_nil: true, only_integer: true }
  validates :email,   presence:   true,
                      uniqueness: { case_sensitive: false },
                      format:     {
                        with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
                      }
  validates :user_id, presence: true

  attr_accessor :card_token

  def self.purchased
    where(status: statuses[:purchased])
  end

  def amount_with_discount
    amount = DEFAULT_PRICE
    amount -= discount.amount if discount
    amount
  end

  def save_with_charge
    return false unless valid?
    return false unless card_token.present?

    charge = create_charge

    self.remote_id = charge.id
    self.amount    = charge.amount

    save
  end

  def to_transaction
    {
      id:      id.to_s,
      revenue: amount_with_discount / 100
    }.to_json
  end

  private

  def create_charge
    Stripe::Charge.create(
      amount:        amount_with_discount,
      source:        card_token,
      currency:      "USD",
      receipt_email: email,
      metadata:      {
        email: email
      }
    )
  end
end
