require "rails_helper"

describe Release do
  it { should validate_presence_of(:description) }

  it { should validate_presence_of(:version) }

  it { should allow_value("1.0.0").for(:version) }
  it { should allow_value("0.1.0").for(:version) }
  it { should allow_value("0.0.1").for(:version) }

  it { should_not allow_value("..").for(:version) }
  it { should_not allow_value("1..").for(:version) }
  it { should_not allow_value("1.0.").for(:version) }
  it { should_not allow_value("a.1.0").for(:version) }
  it { should_not allow_value("1.a.0").for(:version) }
  it { should_not allow_value("1.0.a").for(:version) }
end

describe Release do
  subject { described_class }

  it "defines the path format" do
    expect(subject::PATH_FORMAT).to eq("releases/Fadeaway-%s.%s")
  end

  it "defines valid extensions" do
    expect(subject::VALID_EXTENSIONS).to eq(%w(dmg zip))
  end
end

describe Release, ".latest" do
  subject { described_class }

  let!(:patch) { create(:release, version: "0.0.1") }
  let!(:major) { create(:release, version: "1.0.0") }
  let!(:soon)  { create(:release, version: "2.0.0", released_at: nil) }
  let!(:minor) { create(:release, version: "0.1.0") }

  it "returns the latest release by version" do
    expect(subject.latest).to eq(major)
  end
end

describe Release, ".released" do
  subject { described_class }

  let!(:released)   { create(:release) }
  let!(:unreleased) { create(:release, released_at: nil) }

  it "returns releases with a released_at value" do
    expect(subject.released).to eq([released])
  end
end

describe Release, ".since" do
  subject { described_class }

  let!(:fixes)    { create(:release, version: "0.1.1") }
  let!(:initial)  { create(:release, version: "0.1.0") }
  let!(:patches)  { create(:release, version: "1.1.0") }
  let!(:official) { create(:release, version: "1.0.0") }
  let!(:outdated) { create(:release, version: "0.2.3") }

  it "returns newer releases" do
    expect(subject.since("1.0.0")).to eq([patches])
    expect(subject.since("0.1.1")).to eq([patches, official, outdated])
    expect(subject.since("0.1.0")).to eq([patches, official, outdated, fixes])
  end
end

describe Release, ".ordered_by_version" do
  subject { described_class }

  let!(:patch) { create(:release, version: "0.0.1") }
  let!(:major) { create(:release, version: "1.0.0") }
  let!(:minor) { create(:release, version: "0.1.0") }

  it "returns the releases ordered by version" do
    expect(subject.ordered_by_version).to eq([major, minor, patch])
  end
end

describe Release, "#bucket" do
  let(:bucket) { instance_double(Aws::S3::Bucket) }

  before do
    allow(Aws::S3::Bucket).to receive(:new).and_return(bucket)
  end

  it "creates an S3 bucket instance" do
    subject.bucket

    expect(Aws::S3::Bucket).to have_received(:new).with("getfadeaway")
  end

  it "returns the bucket instance" do
    expect(subject.bucket).to eq(bucket)
  end
end

describe Release, "#ensure_uploaded, when not releasing and uploaded" do
  subject { create(:release) }

  before do
    allow(subject).to receive(:releasing?).and_return(false)
    allow(subject).to receive(:uploaded?).and_return(true)
  end

  it "is valid" do
    expect(subject).to be_valid
  end
end

describe Release, "#ensure_uploaded, when releasing and not uploaded" do
  subject { create(:release) }

  before do
    allow(subject).to receive(:uploaded?).and_return(false)
    allow(subject).to receive(:releasing?).and_return(true)
  end

  it "is not valid" do
    expect(subject).not_to be_valid
    expect(subject.errors[:released_at]).to eq(
      [
        "can not be set without uploaded files"
      ]
    )
  end
end

describe Release, "#logs" do
  subject { create(:release, logs: nil) }

  it "defaults to empty log types" do
    expect(subject.logs).to eq(Release::DEFAULT_LOGS)
  end
end

describe Release, "#releasing?" do
  subject { create(:release, released_at: nil) }

  it "returns true when released_at was nil and is now present" do
    subject.released_at = Time.zone.now

    expect(subject).to be_releasing
  end

  it "returns false when released_at was nil and is still nil" do
    expect(subject).not_to be_releasing
  end

  it "returns false when released_at was set and is still set" do
    subject.update_attribute(:released_at, Time.zone.now)

    expect(subject).not_to be_releasing
  end

  it "returns false when released_at was set and is changed" do
    subject.update_attribute(:released_at, 1.hour.ago)
    subject.released_at = Time.zone.now

    expect(subject).not_to be_releasing
  end

  it "returns false when released_at was set and is nil" do
    subject.update_attribute(:released_at, nil)
    subject.released_at = nil

    expect(subject).not_to be_releasing
  end
end

describe Release, "#uploaded?" do
  subject { create(:release, version: version) }

  let(:bucket)         { instance_double(Aws::S3::Bucket) }
  let(:version)        { "1.13.37" }
  let(:extensions)     { described_class::VALID_EXTENSIONS }
  let(:path_format)    { described_class::PATH_FORMAT }
  let(:missing_object) { instance_double(Aws::S3::Object, exists?: false) }
  let(:present_object) { instance_double(Aws::S3::Object, exists?: true) }

  before do
    allow(subject).to receive(:bucket).and_return(bucket)
  end

  it "returns true if all valid extensions exist" do
    extensions.each do |extension|
      path = format(path_format, version, extension)

      allow(bucket).to receive(:object).with(path).and_return(present_object)
    end

    expect(subject).to be_uploaded
  end

  it "returns false if not all valid extensions exist" do
    extensions.each do |extension|
      path = format(path_format, version, extension)

      allow(bucket).to receive(:object).with(path).and_return(missing_object)
    end

    expect(subject).not_to be_uploaded
  end
end

describe Release, "#url" do
  subject { create(:release, version: version) }

  let(:file)          { instance_double(Aws::S3::Object) }
  let(:version)       { "1.13.0" }
  let(:path_format)   { described_class::PATH_FORMAT }
  let(:presigned_url) { "https://s3.amazon.com" }

  before do
    allow(file).to receive(:presigned_url).and_return(presigned_url)
    allow(subject.bucket).to receive(:object).and_return(file)
  end

  it "retrieves object from bucket for release version" do
    subject.url

    expect(subject.bucket).to have_received(:object)
      .with(format(path_format, version, "zip"))
  end

  it "supports a DMG file extension" do
    subject.url(:dmg)

    expect(subject.bucket).to have_received(:object)
      .with(format(path_format, version, "dmg"))
  end

  it "defaults to ZIP file extension for invalid extensions" do
    subject.url(:tar)

    expect(subject.bucket).to have_received(:object)
      .with(format(path_format, version, "zip"))
  end

  it "generates a presigned URL for the object" do
    subject.url

    expect(file).to have_received(:presigned_url).with(:get, expires_in: 30)
  end

  it "returns the presigned URL" do
    expect(subject.url).to eq(presigned_url)
  end
end
