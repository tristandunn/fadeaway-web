require "rails_helper"

describe Version do
  subject { described_class }

  it "defines a version matcher" do
    expect(subject::MATCHER).to be_a(Regexp)
  end

  it "includes the comparable module" do
    expect(subject.included_modules).to include(Comparable)
  end
end

describe Version, "#parsed" do
  subject { described_class.new(string) }

  let(:major)  { 2 }
  let(:minor)  { 1 }
  let(:patch)  { 3 }
  let(:string) { [major, minor, patch].join(".") }

  it "returns a parsed version as a hash" do
    expect(subject.parsed).to eq(
      major: major,
      minor: minor,
      patch: patch
    )
  end
end

describe Version, "#<=>" do
  it "sorts major versions" do
    v1 = described_class.new("8.0.0")
    v2 = described_class.new("3.0.0")
    v3 = described_class.new("1.5.3")

    expect([v1, v3, v2].sort).to eq([v3, v2, v1])
  end

  it "sorts minor versions" do
    v1 = described_class.new("1.8.0")
    v2 = described_class.new("1.3.0")
    v3 = described_class.new("1.1.3")

    expect([v1, v3, v2].sort).to eq([v3, v2, v1])
  end

  it "sorts patch versions" do
    v1 = described_class.new("1.1.8")
    v2 = described_class.new("1.1.3")
    v3 = described_class.new("1.1.1")

    expect([v1, v3, v2].sort).to eq([v3, v2, v1])
  end
end

describe Version, "#to_a" do
  subject { described_class.new(string) }

  let(:major)  { 2 }
  let(:minor)  { 1 }
  let(:patch)  { 3 }
  let(:string) { [major, minor, patch].join(".") }

  it "returns an array of version parts in order" do
    expect(subject.to_a).to eq([major, minor, patch])
  end
end

describe Version, "#to_s" do
  subject { described_class.new(string) }

  let(:string) { "0.1.0" }

  it "returns the raw value" do
    expect(subject.to_s).to eq(string)
  end
end
