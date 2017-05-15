require "rails_helper"

describe RefundDashboard do
  it "defines attribute types" do
    expect(RefundDashboard::ATTRIBUTE_TYPES).to eq(
      order:      Administrate::Field::BelongsTo,
      id:         Administrate::Field::Number,
      remote_id:  Administrate::Field::String,
      amount:     Administrate::Field::Number.with_options(
        decimals:   2,
        multiplier: 0.01,
        prefix:     "$"
      ),
      created_at: Administrate::Field::DateTime
    )
  end

  it "defines collection attributes" do
    expect(RefundDashboard::COLLECTION_ATTRIBUTES).to eq(
      [
        :order,
        :id,
        :amount,
        :created_at
      ]
    )
  end

  it "defines show page attributes" do
    expect(RefundDashboard::SHOW_PAGE_ATTRIBUTES).to eq(
      [
        :order,
        :id,
        :remote_id,
        :amount,
        :created_at
      ]
    )
  end

  it "defines form attributes" do
    expect(RefundDashboard::FORM_ATTRIBUTES).to eq([])
  end
end
