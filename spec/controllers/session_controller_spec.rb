require "rails_helper"

describe SessionController, "#new" do
  let(:id)    { 1234 }
  let(:code)  { SecureRandom.hex(32) }
  let(:data)  { { id: id, name: name, type: "Player" } }
  let(:name)  { "Bob" }
  let(:user)  { create(:user) }
  let(:token) { instance_double(Token) }

  before do
    allow(User).to receive(:find_or_initialize_by).and_return(user)
    allow(token).to receive(:get).and_return(data)
    allow(Token).to receive(:create_from_code).and_return(token)

    get :new, code: code
  end

  it { should redirect_to(new_order_path) }
  it { should set_session[:user_id].to(user.id) }

  it "creates a token from the code parameter" do
    expect(Token).to have_received(:create_from_code).with(:web, code)
  end

  it "gets user information for the token" do
    expect(token).to have_received(:get).with("/v1/user")
  end

  it "finds or initializes a user based on their remote ID" do
    expect(User).to have_received(:find_or_initialize_by).with(remote_id: id)
  end

  it "updates the user's name" do
    user.reload

    expect(user.name).to eq(name)
  end
end

describe SessionController, "#new, for a user with an order" do
  let(:id)    { 1234 }
  let(:code)  { SecureRandom.hex(32) }
  let(:data)  { { id: id, name: name, type: "Player" } }
  let(:name)  { "Bob" }
  let(:user)  { order.user }
  let(:order) { create(:order) }
  let(:token) { instance_double(Token) }

  before do
    allow(User).to receive(:find_or_initialize_by).and_return(user)
    allow(token).to receive(:get).and_return(data)
    allow(Token).to receive(:create_from_code).and_return(token)

    get :new, code: code
  end

  it { should redirect_to(dashboard_index_path) }
  it { should set_session[:user_id].to(user.id) }

  it "creates a token from the code parameter" do
    expect(Token).to have_received(:create_from_code).with(:web, code)
  end

  it "gets user information for the token" do
    expect(token).to have_received(:get).with("/v1/user")
  end

  it "finds or initializes a user based on their remote ID" do
    expect(User).to have_received(:find_or_initialize_by).with(remote_id: id)
  end

  it "updates the user's name" do
    user.reload

    expect(user.name).to eq(name)
  end
end

describe SessionController, "#new, for a prospect" do
  let(:code)  { SecureRandom.hex(32) }
  let(:data)  { { id: 1234, name: "Bob", type: "Prospect" } }
  let(:token) { instance_double(Token) }

  before do
    allow(User).to receive(:find_or_initialize_by)
    allow(token).to receive(:get).and_return(data)
    allow(Token).to receive(:create_from_code).and_return(token)

    get :new, code: code
  end

  it { should redirect_to(order_index_path) }
  it { should set_flash[:error].to("prospect") }

  it "creates a token from the code parameter" do
    expect(Token).to have_received(:create_from_code).with(:web, code)
  end

  it "gets user information for the token" do
    expect(token).to have_received(:get).with("/v1/user")
  end

  it "does not attempt to find or initialize a user" do
    expect(User).not_to receive(:find_or_initialize_by)
  end
end

describe SessionController, "#new, with an OAuth error" do
  let(:error)       { OAuth2::Error.new(reply) }
  let(:reply)       { instance_double("reply") }
  let(:description) { "An error occurred." }

  before do
    allow(reply).to receive(:error=)
    allow(reply).to receive(:body).and_return("")
    allow(reply).to receive(:parsed)
      .and_return("error_description" => description)

    allow(Token).to receive(:create_from_code).and_raise(error)

    get :new, code: "code"
  end

  it { should redirect_to(order_index_path) }
  it do
    should set_flash[:error]
      .to("An error occurred while connecting to Dribbble. Please try again.")
  end
end

describe SessionController, "#new, with a user error" do
  before do
    get :new, error: "access_denied"
  end

  it { should redirect_to(order_index_path) }
  it { should set_flash[:error].to("access_denied") }
end

describe SessionController, "#new, without a code" do
  it "raises an error" do
    expect { get :new }.to raise_error(ActionController::ParameterMissing)
  end
end

describe SessionController, "#new, for the desktop" do
  before do
    allow(User).to receive(:find_or_initialize_by)
    allow(Token).to receive(:create_from_code)

    get :new, state: "desktop"
  end

  it { should respond_with(200) }

  it "does not attempt to create a token" do
    expect(Token).not_to receive(:create_from_code)
  end

  it "does not attempt to find or initialize a user" do
    expect(User).not_to receive(:find_or_initialize_by)
  end
end

describe SessionController, "#destroy" do
  before do
    sign_in

    delete :destroy
  end

  it { should redirect_to(root_path) }
  it { should_not set_session[:user_id] }
end
