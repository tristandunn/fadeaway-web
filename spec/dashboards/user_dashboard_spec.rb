require "rails_helper"

describe UserDashboard do
  it "defines attribute types" do
    expect(UserDashboard::ATTRIBUTE_TYPES).to eq(
      orders:     Administrate::Field::HasMany,
      id:         Administrate::Field::Number,
      remote_id:  Administrate::Field::Number,
      name:       Administrate::Field::String,
      created_at: Administrate::Field::DateTime,
      updated_at: Administrate::Field::DateTime
    )
  end

  it "defines collection attributes" do
    expect(UserDashboard::COLLECTION_ATTRIBUTES).to eq(
      [
        :id,
        :remote_id,
        :name,
        :created_at
      ]
    )
  end

  it "defines show page attributes" do
    expect(UserDashboard::SHOW_PAGE_ATTRIBUTES).to eq(
      [
        :orders,
        :id,
        :remote_id,
        :name,
        :created_at,
        :updated_at
      ]
    )
  end

  it "defines form attributes" do
    expect(UserDashboard::FORM_ATTRIBUTES).to eq([])
  end
end

describe UserDashboard, "#display_resource" do
  let(:user) { build_stubbed(:user) }

  it "returns the user name" do
    expect(subject.display_resource(user)).to eq(user.name)
  end
end
