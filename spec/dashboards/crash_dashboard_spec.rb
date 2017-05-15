require "rails_helper"

describe CrashDashboard do
  it "defines attribute types" do
    expect(CrashDashboard::ATTRIBUTE_TYPES).to eq(
      user:       Administrate::Field::BelongsTo,
      id:         Administrate::Field::Number,
      version:    Administrate::Field::String,
      system:     Administrate::Field::Text,
      created_at: Administrate::Field::DateTime
    )
  end

  it "defines collection attributes" do
    expect(CrashDashboard::COLLECTION_ATTRIBUTES).to eq(
      [
        :user,
        :version,
        :system,
        :created_at
      ]
    )
  end

  it "defines show page attributes" do
    expect(CrashDashboard::SHOW_PAGE_ATTRIBUTES).to eq(
      [
        :user,
        :id,
        :version,
        :system,
        :created_at
      ]
    )
  end

  it "defines form attributes" do
    expect(CrashDashboard::FORM_ATTRIBUTES).to eq([])
  end
end
