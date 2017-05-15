require "rails_helper"

describe UpdateController, "#show, for an old version" do
  let!(:release) { create(:release, version: "0.2.0") }

  let(:notes) do
    subject.render_to_string locals:     { client: true },
                             partial:    "releases/release.html",
                             collection: [release]
  end

  before do
    get :show, id: "0.1.0"
  end

  it { should respond_with(:success) }

  it "renders the latest release as JSON" do
    expect(response.body).to eq({
      url:   release_url(release),
      name:  release.version.to_s,
      notes: notes
    }.to_json)
  end
end

describe UpdateController, "#show, for an old version with a token" do
  let(:data)         { { id: user.remote_id } }
  let(:user)         { create(:user) }
  let(:token)        { instance_double(Token) }
  let!(:release)     { create(:release, version: "0.2.0") }
  let(:access_token) { SecureRandom.hex(32) }

  let(:notes) do
    subject.render_to_string locals:     { client: true },
                             partial:    "releases/release.html",
                             collection: [release]
  end

  before do
    allow(token).to receive(:get).and_return(data)
    allow(Token).to receive(:new).and_return(token)

    get :show, id: "0.1.0", access_token: access_token
  end

  it { should respond_with(:success) }

  it "renders the latest release as JSON" do
    expect(response.body).to eq({
      url:   release_url(release, access_token: access_token),
      name:  release.version.to_s,
      notes: notes
    }.to_json)
  end
end

describe UpdateController, "#show, for an old version with new versions" do
  let!(:release_1) { create(:release, version: "0.2.0") }
  let!(:release_2) { create(:release, version: "0.3.0") }

  let(:notes) do
    subject.render_to_string locals:     { client: true },
                             partial:    "releases/release.html",
                             collection: [release_2, release_1]
  end

  before do
    get :show, id: "0.1.0"
  end

  it { should respond_with(:success) }

  it "renders the latest release as JSON" do
    expect(response.body).to eq({
      url:   release_url(release_2),
      name:  release_2.version.to_s,
      notes: notes
    }.to_json)
  end
end

describe UpdateController, "#show, for the latest version" do
  let(:release) { create(:release) }

  before do
    allow(Release).to receive(:latest).and_return(release)

    get :show, id: release.version
  end

  it { should respond_with(:no_content) }
end
