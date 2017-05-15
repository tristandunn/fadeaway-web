require "rails_helper"

describe CrashesController, "#create" do
  let(:os_arch)      { "x64" }
  let(:version)      { "0.1.2" }
  let(:os_release)   { "15.3.0" }
  let(:memory_free)  { 9_026_244_608 }
  let(:memory_total) { 17_179_869_184 }

  before do
    post :create, memory_free:  memory_free,
                  memory_total: memory_total,
                  os_arch:      os_arch,
                  os_release:   os_release,
                  _version:     version
  end

  it { should respond_with(:success) }

  it "creates a crash" do
    crash = Crash.first

    expect(crash).to be_a(Crash)
    expect(crash.user).to be_nil
    expect(crash.version).to eq(version)
    expect(crash.system["memory_free"]).to eq(memory_free)
    expect(crash.system["memory_total"]).to eq(memory_total)
    expect(crash.system["os_arch"]).to eq(os_arch)
    expect(crash.system["os_release"]).to eq(os_release)
  end
end

describe CrashesController, "#create, with a valid access token" do
  let(:data)         { { id: user.remote_id } }
  let(:user)         { create(:user) }
  let(:token)        { instance_double(Token) }
  let(:os_arch)      { "x64" }
  let(:version)      { "0.1.2" }
  let(:os_release)   { "15.3.0" }
  let(:access_token) { SecureRandom.hex(32) }
  let(:memory_free)  { 9_026_244_608 }
  let(:memory_total) { 17_179_869_184 }

  before do
    allow(token).to receive(:get).and_return(data)
    allow(Token).to receive(:new).and_return(token)

    post :create, access_token: access_token,
                  memory_free:  memory_free,
                  memory_total: memory_total,
                  os_arch:      os_arch,
                  os_release:   os_release,
                  _version:     version
  end

  it { should respond_with(:success) }

  it "creates a token with the provided access token" do
    expect(Token).to have_received(:new).with(:desktop, access_token)
  end

  it "gets user information for the token" do
    expect(token).to have_received(:get).with("/v1/user")
  end

  it "creates a crash" do
    crash = Crash.first

    expect(crash).to be_a(Crash)
    expect(crash.user).to eq(user)
    expect(crash.version).to eq(version)
    expect(crash.system["memory_free"]).to eq(memory_free)
    expect(crash.system["memory_total"]).to eq(memory_total)
    expect(crash.system["os_arch"]).to eq(os_arch)
    expect(crash.system["os_release"]).to eq(os_release)
  end
end
