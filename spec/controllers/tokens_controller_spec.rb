require "rails_helper"

describe TokensController, "#create" do
  let(:code)  { SecureRandom.hex(32) }
  let(:data)  { { id: user.id } }
  let(:user)  { order.user }
  let(:order) { create(:order) }
  let(:token) { instance_double(Token) }
  let(:value) { SecureRandom.hex(32) }

  before do
    allow(User).to receive(:find_by).and_return(user)
    allow(token).to receive(:get).and_return(data)
    allow(token).to receive(:value).and_return(value)
    allow(Token).to receive(:create_from_code).and_return(token)

    post :create, code: code
  end

  it { should respond_with(:success) }

  it "creates a token from the code parameter" do
    expect(Token).to have_received(:create_from_code).with(:desktop, code)
  end

  it "gets user information for the token" do
    expect(token).to have_received(:get).with("/v1/user")
  end

  it "finds the user based on their remote ID" do
    expect(User).to have_received(:find_by).with(remote_id: data[:id])
  end

  it "renders the token" do
    expect(response.body).to eq(value)
  end
end

describe TokensController, "#create, without a code" do
  it "raises an error" do
    expect { post :create }.to raise_error(ActionController::ParameterMissing)
  end
end

describe TokensController, "#create, without an order" do
  let(:code)  { SecureRandom.hex(32) }
  let(:data)  { { id: user.id } }
  let(:user)  { create(:user) }
  let(:token) { instance_double(Token) }
  let(:value) { SecureRandom.hex(32) }

  before do
    allow(User).to receive(:find_by).and_return(user)
    allow(token).to receive(:get).and_return(data)
    allow(token).to receive(:value).and_return(value)
    allow(Token).to receive(:create_from_code).and_return(token)

    post :create, code: code
  end

  it { should respond_with(:unauthorized) }

  it "creates a token from the code parameter" do
    expect(Token).to have_received(:create_from_code).with(:desktop, code)
  end

  it "gets user information for the token" do
    expect(token).to have_received(:get).with("/v1/user")
  end

  it "finds the user based on their remote ID" do
    expect(User).to have_received(:find_by).with(remote_id: data[:id])
  end

  it "does not render the token" do
    expect(response.body).not_to eq(value)
  end
end

describe TokensController, "#create, with an OAuth error" do
  let(:code)        { SecureRandom.hex(32) }
  let(:error)       { OAuth2::Error.new(reply) }
  let(:reply)       { instance_double(OAuth2::Response) }
  let(:description) { "An error occurred." }

  before do
    allow(reply).to receive(:error=)
    allow(reply).to receive(:body).and_return("")
    allow(reply).to receive(:parsed)
      .and_return("error_description" => description)

    allow(Token).to receive(:create_from_code).and_raise(error)

    post :create, code: code
  end

  it { should respond_with(:unauthorized) }

  it "attempts to create a token from the code parameter" do
    expect(Token).to have_received(:create_from_code).with(:desktop, code)
  end

  it "renders the error description" do
    expect(response.body).to eq(description)
  end
end
