require "rails_helper"

describe Token do
  subject { described_class }

  it "defines a client ID constant" do
    expect(subject::CLIENT_ID).to eq(
      web:     ENV["DRIBBBLE_WEB_ID"],
      desktop: ENV["DRIBBBLE_DESKTOP_ID"]
    )
  end

  it "defines a client scope constant" do
    expect(subject::CLIENT_SCOPE).to eq("public")
  end

  it "defines a client secret constant" do
    expect(subject::CLIENT_SECRET).to eq(
      web:     ENV["DRIBBBLE_WEB_SECRET"],
      desktop: ENV["DRIBBBLE_DESKTOP_SECRET"]
    )
  end

  it "defines a client options constant" do
    expect(subject::CLIENT_OPTIONS).to eq(
      site:          "https://api.dribbble.com",
      token_url:     "https://dribbble.com/oauth/token",
      authorize_url: "https://dribbble.com/oauth/authorize"
    )
  end
end

describe Token, "#initialize" do
  subject { described_class.new(type, value) }

  let(:type)   { :web }
  let(:value)  { instance_double("value") }
  let(:client) { instance_double("client") }

  before do
    allow(described_class).to receive(:client).and_return(client)
  end

  it "assigns provided token value" do
    expect(subject.value).to eq(value)
  end

  it "creates a client for provided type" do
    subject

    expect(described_class).to have_received(:client).with(type)
  end

  it "assigns created client" do
    expect(subject.client).to eq(client)
  end
end

describe Token, ".authorize_url" do
  subject { described_class }

  let(:url)    { instance_double("url") }
  let(:code)   { instance_double("code") }
  let(:scope)  { subject::CLIENT_SCOPE }
  let(:client) { instance_double("client") }

  before do
    allow(code).to receive(:authorize_url).and_return(url)
    allow(client).to receive(:auth_code).and_return(code)
    allow(subject).to receive(:client).with(:web).and_return(client)
  end

  it "returns the authroize URL from the client" do
    expect(subject.authorize_url).to eq(url)
    expect(code).to have_received(:authorize_url).with(scope: scope)
  end
end

describe Token, ".client, for the web" do
  subject { described_class }

  let(:id)      { subject::CLIENT_ID[:web] }
  let(:url)     { instance_double("url") }
  let(:code)    { instance_double("code") }
  let(:client)  { instance_double("client") }
  let(:secret)  { subject::CLIENT_SECRET[:web] }
  let(:options) { subject::CLIENT_OPTIONS }

  before do
    allow(OAuth2::Client).to receive(:new).and_return(client)
  end

  it "creates an OAuth client" do
    subject.client(:web)

    expect(OAuth2::Client).to have_received(:new).with(id, secret, options)
  end

  it "returns the client" do
    expect(subject.client(:web)).to eq(client)
  end
end

describe Token, ".client, for the desktop" do
  subject { described_class }

  let(:id)      { subject::CLIENT_ID[:desktop] }
  let(:url)     { instance_double("url") }
  let(:code)    { instance_double("code") }
  let(:client)  { instance_double("client") }
  let(:secret)  { subject::CLIENT_SECRET[:desktop] }
  let(:options) { subject::CLIENT_OPTIONS }

  before do
    allow(OAuth2::Client).to receive(:new).and_return(client)
  end

  it "creates an OAuth client" do
    subject.client(:desktop)

    expect(OAuth2::Client).to have_received(:new).with(id, secret, options)
  end

  it "returns the client" do
    expect(subject.client(:desktop)).to eq(client)
  end
end

describe Token, ".create_from_code" do
  subject { described_class }

  let(:type)         { :web }
  let(:token)        { instance_double("token") }
  let(:client)       { instance_double("client") }
  let(:instance)     { instance_double("instance") }
  let(:auth_code)    { instance_double("auth_code") }
  let(:remote_code)  { SecureRandom.hex(32) }
  let(:remote_token) { SecureRandom.hex(32) }

  before do
    allow(token).to receive(:token).and_return(remote_token)
    allow(auth_code).to receive(:get_token).and_return(token)
    allow(client).to receive(:auth_code).and_return(auth_code)
    allow(subject).to receive(:client).and_return(client)
    allow(subject).to receive(:new).and_return(instance)
  end

  it "creates a token with the provided code" do
    subject.create_from_code(type, remote_code)

    expect(auth_code).to have_received(:get_token).with(remote_code)
  end

  it "creates an instance with the remote token value" do
    subject.create_from_code(type, remote_code)

    expect(subject).to have_received(:new).with(type, remote_token)
  end

  it "returns the token instance" do
    expect(subject.create_from_code(type, remote_code)).to eq(instance)
  end
end

describe Token, "#get" do
  subject { described_class.new(type, 1234) }

  let(:type)     { :web }
  let(:path)     { "/v1/user" }
  let(:token)    { instance_double("token") }
  let(:result)   { { "id" => 1 } }
  let(:response) { instance_double("response") }

  before do
    allow(token).to receive(:get).and_return(response)
    allow(subject).to receive(:token).and_return(token)
    allow(response).to receive(:parsed).and_return(result)
  end

  it "gets the path with the token" do
    subject.get(path)

    expect(token).to have_received(:get).with(path)
  end

  it "parses the response" do
    subject.get(path)

    expect(response).to have_received(:parsed)
  end

  it "returns the parsed response" do
    expect(subject.get(path)).to eq(result)
  end

  it "allows indifferent access on the parsed response" do
    result = subject.get(path)

    expect(result[:id]).to eq(result["id"])
  end
end

describe Token, "#token" do
  subject { described_class.new(type, value) }

  let(:type)   { :web }
  let(:token)  { instance_double("token") }
  let(:value)  { instance_double("value") }
  let(:client) { instance_double("client") }

  before do
    allow(subject).to receive(:client).and_return(client)
    allow(OAuth2::AccessToken).to receive(:new).and_return(token)
  end

  it "creates an access token with the client and value" do
    subject.token

    expect(OAuth2::AccessToken).to have_received(:new).with(client, value)
  end

  it "returns the access token" do
    expect(subject.token).to eq(token)
  end

  it "caches the access token" do
    subject.token
    subject.token

    expect(OAuth2::AccessToken).to have_received(:new).once
  end
end
