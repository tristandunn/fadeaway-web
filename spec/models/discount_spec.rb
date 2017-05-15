require "rails_helper"

describe Discount do
  subject { create(:discount) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }

  it do
    should validate_numericality_of(:amount).only_integer.is_greater_than(0)
  end
end

describe Discount do
  subject { described_class }

  it "defines valid sources" do
    expect(subject::SOURCES).to eq(
      "designernews" => "Designer News",
      "producthunt"  => "Product Hunt"
    )
  end
end

describe Discount, ".from_source" do
  subject { described_class }

  let(:name)      { subject::SOURCES[source.downcase] }
  let(:source)    { "dESiGNERnews" }
  let!(:discount) { create(:discount, name: name) }

  it "returns a discount for a valid source" do
    expect(subject.from_source(source)).to eq(discount)
  end

  it "does not return a discount for an invalid source" do
    expect(subject.from_source("behance")).to be_nil
  end

  it "does not return a discount with no source" do
    expect(subject.from_source(nil)).to be_nil
  end
end
