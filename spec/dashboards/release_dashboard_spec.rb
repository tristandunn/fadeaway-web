require "rails_helper"

describe ReleaseDashboard do
  it "defines attribute types" do
    expect(ReleaseDashboard::ATTRIBUTE_TYPES).to eq(
      id:          Administrate::Field::Number,
      version:     Administrate::Field::String,
      description: Administrate::Field::Text,
      logs:        Administrate::Field::Text,
      created_at:  Administrate::Field::DateTime,
      released_at: Administrate::Field::DateTime
    )
  end

  it "defines collection attributes" do
    expect(ReleaseDashboard::COLLECTION_ATTRIBUTES).to eq(
      [
        :id,
        :version,
        :description,
        :released_at
      ]
    )
  end

  it "defines show page attributes" do
    expect(ReleaseDashboard::SHOW_PAGE_ATTRIBUTES).to eq(
      [
        :id,
        :version,
        :description,
        :created_at,
        :released_at,
        :logs
      ]
    )
  end

  it "defines form attributes" do
    expect(ReleaseDashboard::FORM_ATTRIBUTES).to eq(
      [
        :version,
        :description,
        :logs,
        :released_at
      ]
    )
  end
end

describe ReleaseDashboard, "#display_resource" do
  let(:release) { build_stubbed(:release) }

  it "returns the release version" do
    expect(subject.display_resource(release)).to eq(release.version)
  end
end
