require "rails_helper"

class ExampleController < ActionController::Base
  include Authentication
end

describe Authentication do
  it "defines administrator IDs" do
    expect(Authentication::ADMINISTRATORS).to eq([3290])
  end
end

describe Authentication, ".helpers" do
  subject { ExampleController._helper_methods }

  it "includes administrator? method" do
    expect(subject).to include(:administrator?)
  end

  it "includes current_user method" do
    expect(subject).to include(:current_user)
  end

  it "includes signed_in? method" do
    expect(subject).to include(:signed_in?)
  end
end

describe Authentication, "#administrator?, with a user" do
  subject { ExampleController.new }

  let(:user) { build_stubbed(:user) }

  before do
    allow(subject).to receive(:current_user).and_return(user)
  end

  it "returns false" do
    expect(subject).not_to be_administrator
  end
end

describe Authentication, "#administrator?, with no user" do
  subject { ExampleController.new }

  before do
    allow(subject).to receive(:current_user).and_return(nil)
  end

  it "returns false" do
    expect(subject).not_to be_administrator
  end
end

describe Authentication, "#administrator?, with an administrator" do
  subject { ExampleController.new }

  let(:user) do
    build_stubbed(:user, remote_id: Authentication::ADMINISTRATORS.first)
  end

  before do
    allow(subject).to receive(:current_user).and_return(user)
  end

  it "returns true" do
    expect(subject).to be_administrator
  end
end

describe Authentication, "#current_user, with a user loaded" do
  subject { ExampleController.new }

  let(:user) { build_stubbed(:user) }

  before do
    allow(subject).to receive(:user_from_token)
    allow(subject).to receive(:user_from_session)

    subject.instance_variable_set("@current_user", user)
  end

  it "does not attempt to load a user from the session" do
    subject.current_user

    expect(subject).not_to have_received(:user_from_session)
  end

  it "does not attempt to load a user from the token" do
    subject.current_user

    expect(subject).not_to have_received(:user_from_token)
  end

  it "returns the user" do
    expect(subject.current_user).to eq(user)
  end
end

describe Authentication, "#current_user, with a user in the session" do
  subject { ExampleController.new }

  let(:user) { build_stubbed(:user) }

  before do
    allow(subject).to receive(:user_from_token).and_return(nil)
    allow(subject).to receive(:user_from_session).and_return(user)
  end

  it "loads the user from the session" do
    subject.current_user

    expect(subject).to have_received(:user_from_session)
  end

  it "assigns the user to the instance variable" do
    subject.current_user

    expect(subject.instance_variable_get("@current_user")).to eq(user)
  end

  it "returns the user" do
    expect(subject.current_user).to eq(user)
  end
end

describe Authentication, "#current_user, with a user from a token" do
  subject { ExampleController.new }

  let(:user) { build_stubbed(:user) }

  before do
    allow(subject).to receive(:user_from_token).and_return(user)
    allow(subject).to receive(:user_from_session).and_return(nil)
  end

  it "attempts to load the user from the session" do
    subject.current_user

    expect(subject).to have_received(:user_from_session)
  end

  it "loads the user from the token" do
    subject.current_user

    expect(subject).to have_received(:user_from_token)
  end

  it "assigns the user to the instance variable" do
    subject.current_user

    expect(subject.instance_variable_get("@current_user")).to eq(user)
  end

  it "returns the user" do
    expect(subject.current_user).to eq(user)
  end
end

describe Authentication, "#current_user, with no user in the session" do
  subject { ExampleController.new }

  before do
    allow(subject).to receive(:user_from_token).and_return(nil)
    allow(subject).to receive(:user_from_session).and_return(nil)
  end

  it "attempts to load a user from the session" do
    subject.current_user

    expect(subject).to have_received(:user_from_session)
  end

  it "assigns :false to the instance variable" do
    subject.current_user

    expect(subject.instance_variable_get("@current_user")).to eq(:false)
  end

  it "returns :false" do
    expect(subject.current_user).to eq(:false)
  end
end

describe Authentication, "#current_user=, assigned a user" do
  subject { ExampleController.new }

  let(:user)    { build_stubbed(:user) }
  let(:session) { {} }

  before do
    allow(subject).to receive(:session).and_return(session)

    subject.current_user = user
  end

  it "assigns the user ID to the session" do
    expect(subject.session[:user_id]).to eq(user.id)
  end

  it "assigns the user to the instance variable" do
    expect(subject.instance_variable_get("@current_user")).to eq(user)
  end
end

describe Authentication, "#current_user=, when not assigned a user" do
  subject { ExampleController.new }

  let(:session) { {} }

  before do
    allow(subject).to receive(:session).and_return(session)

    subject.current_user = false
  end

  it "assigns nil to session" do
    expect(subject.session[:user_id]).to be_nil
  end

  it "assigns nil to instance variable" do
    expect(subject.instance_variable_get("@current_user")).to be_nil
  end
end

describe Authentication, "#signed_in?, with a user present" do
  subject { ExampleController.new }

  before do
    allow(subject).to receive(:current_user).and_return(true)
  end

  it "returns true" do
    expect(subject).to be_signed_in
  end
end

describe Authentication, "#signed_in?, with no user present" do
  subject { ExampleController.new }

  before do
    allow(subject).to receive(:current_user).and_return(:false)
  end

  it "returns false" do
    expect(subject).not_to be_signed_in
  end
end

describe Authentication, "#user_from_session, with a user ID in the session" do
  subject { ExampleController.new }

  let(:user)    { build_stubbed(:user) }
  let(:session) { { user_id: user.id } }

  before do
    allow(subject).to receive(:current_user=)
    allow(subject).to receive(:session).and_return(session)

    allow(User).to receive(:find).and_return(user)
  end

  it "attempts to find the user" do
    subject.user_from_session

    expect(User).to have_received(:find).with(session[:user_id])
  end

  it "assigns the user to current_user" do
    subject.user_from_session

    expect(subject).to have_received(:current_user=).with(user)
  end

  it "returns the user" do
    expect(subject.user_from_session).to eq(user)
  end
end

describe Authentication, "#user_from_session, with no user ID in the session" do
  subject { ExampleController.new }

  let(:session) { {} }

  before do
    allow(subject).to receive(:current_user=)
    allow(subject).to receive(:session).and_return(session)

    allow(User).to receive(:find)
  end

  it "does not attempt to find the user" do
    subject.user_from_session

    expect(User).not_to have_received(:find)
  end

  it "does not assign current_user" do
    subject.user_from_session

    expect(subject).not_to have_received(:current_user=)
  end

  it "returns nil" do
    expect(subject.user_from_session).to be_nil
  end
end

describe Authentication, "#user_from_token, with an access token" do
  subject { ExampleController.new }

  let(:user)         { build_stubbed(:user) }
  let(:data)         { { id: user.remote_id } }
  let(:token)        { instance_double(Token) }
  let(:params)       { { access_token: access_token } }
  let(:access_token) { SecureRandom.hex(32) }

  before do
    allow(subject).to receive(:current_user=)
    allow(subject).to receive(:params).and_return(params)

    allow(User).to receive(:find_by).and_return(user)
    allow(token).to receive(:get).and_return(data)
    allow(Token).to receive(:new).and_return(token)
  end

  it "creates a token with the access token" do
    subject.user_from_token

    expect(Token).to have_received(:new).with(:desktop, access_token)
  end

  it "gets user information for the token" do
    subject.user_from_token

    expect(token).to have_received(:get).with("/v1/user")
  end

  it "attempts to find the user" do
    subject.user_from_token

    expect(User).to have_received(:find_by).with(remote_id: data[:id])
  end

  it "assigns the user to current_user" do
    subject.user_from_token

    expect(subject).to have_received(:current_user=).with(user)
  end

  it "returns the user" do
    expect(subject.user_from_token).to eq(user)
  end
end

describe Authentication, "#user_from_token, with no access token" do
  subject { ExampleController.new }

  let(:user)   { build_stubbed(:user) }
  let(:data)   { { id: user.remote_id } }
  let(:params) { {} }

  before do
    allow(subject).to receive(:current_user=)
    allow(subject).to receive(:params).and_return(params)

    allow(User).to receive(:find_by)
    allow(Token).to receive(:new)
  end

  it "does not create a token" do
    subject.user_from_token

    expect(Token).not_to have_received(:new)
  end

  it "does not attempt to find the user" do
    subject.user_from_token

    expect(User).not_to have_received(:find_by)
  end

  it "does not assign current_user" do
    subject.user_from_token

    expect(subject).not_to have_received(:current_user=)
  end

  it "returns nil" do
    expect(subject.user_from_token).to be_nil
  end
end

describe Authentication, "#user_from_token, with an invalid access token" do
  subject { ExampleController.new }

  let(:token)        { instance_double(Token) }
  let(:params)       { { access_token: access_token } }
  let(:access_token) { SecureRandom.hex(32) }

  before do
    allow(subject).to receive(:current_user=)
    allow(subject).to receive(:params).and_return(params)

    allow(User).to receive(:find_by)
    allow(token).to receive(:get).and_raise
    allow(Token).to receive(:new).and_return(token)
  end

  it "creates a token with the access token" do
    subject.user_from_token

    expect(Token).to have_received(:new).with(:desktop, access_token)
  end

  it "attempts to get user information for the token" do
    subject.user_from_token

    expect(token).to have_received(:get).with("/v1/user")
  end

  it "does not assign current_user" do
    subject.user_from_token

    expect(subject).not_to have_received(:current_user=)
  end

  it "returns nil" do
    expect(subject.user_from_token).to be_nil
  end
end
