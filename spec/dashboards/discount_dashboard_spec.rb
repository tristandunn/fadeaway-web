require "rails_helper"

describe DiscountDashboard do
  it "defines attribute types" do
    expect(DiscountDashboard::ATTRIBUTE_TYPES).to eq(
      id:         Administrate::Field::Number,
      name:       Administrate::Field::String,
      amount:     Administrate::Field::Number.with_options(
        decimals:   2,
        multiplier: 0.01,
        prefix:     "$"
      ),
      created_at: Administrate::Field::DateTime,
      updated_at: Administrate::Field::DateTime
    )
  end

  it "defines collection attributes" do
    expect(DiscountDashboard::COLLECTION_ATTRIBUTES).to eq(
      [
        :id,
        :name,
        :amount,
        :created_at,
        :updated_at
      ]
    )
  end

  it "defines show page attributes" do
    expect(DiscountDashboard::SHOW_PAGE_ATTRIBUTES).to eq(
      [
        :id,
        :name,
        :amount,
        :created_at,
        :updated_at
      ]
    )
  end

  it "defines form attributes" do
    expect(DiscountDashboard::FORM_ATTRIBUTES).to eq(
      [
        :name,
        :amount
      ]
    )
  end
end

describe DiscountDashboard, "#display_resource" do
  let(:discount) { build_stubbed(:discount) }

  it "returns the discount name" do
    expect(subject.display_resource(discount)).to eq(discount.name)
  end
end
