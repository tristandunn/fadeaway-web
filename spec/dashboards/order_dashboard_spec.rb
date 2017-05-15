require "rails_helper"

describe OrderDashboard do
  it "defines attribute types" do
    expect(OrderDashboard::ATTRIBUTE_TYPES).to eq(
      discount:   Administrate::Field::BelongsTo,
      user:       Administrate::Field::BelongsTo,
      refunds:    Administrate::Field::HasMany,
      id:         Administrate::Field::Number,
      remote_id:  Administrate::Field::String,
      email:      Administrate::Field::String,
      amount:     Administrate::Field::Number.with_options(
        decimals:   2,
        multiplier: 0.01,
        prefix:     "$"
      ),
      status:     Administrate::Field::String,
      created_at: Administrate::Field::DateTime,
      updated_at: Administrate::Field::DateTime
    )
  end

  it "defines collection attributes" do
    expect(OrderDashboard::COLLECTION_ATTRIBUTES).to eq(
      [
        :user,
        :id,
        :email,
        :amount,
        :status,
        :created_at
      ]
    )
  end

  it "defines show page attributes" do
    expect(OrderDashboard::SHOW_PAGE_ATTRIBUTES).to eq(
      [
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
      ]
    )
  end

  it "defines form attributes" do
    expect(OrderDashboard::FORM_ATTRIBUTES).to eq([])
  end
end
