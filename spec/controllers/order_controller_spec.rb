require "rails_helper"

describe OrderController, "#index" do
  before do
    get :index
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#index, when signed in" do
  before do
    sign_in

    get :index
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#index, with an access denied error" do
  before do
    allow(subject).to receive(:flash).and_return(error: "access_denied")

    get :index
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#index, with a prospect error" do
  before do
    allow(subject).to receive(:flash).and_return(error: "prospect")

    get :index
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#new" do
  let(:user)   { create(:user) }
  let(:amount) { Order::DEFAULT_PRICE / 100 }

  before do
    sign_in_as(user)

    get :new
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#new, with a discount" do
  let(:user)     { create(:user) }
  let(:amount)   { (Order::DEFAULT_PRICE - discount.amount) / 100 }
  let(:discount) { create(:discount, amount: 5_00) }

  before do
    session[:discount_id] = discount.id

    sign_in_as(user)

    get :new
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#new, when signed out" do
  before do
    get :new
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#create" do
  let(:user)       { build_stubbed(:user) }
  let(:order)      { build_stubbed(:order, user: user) }
  let(:token)      { "tok_1234" }
  let(:orders)     { instance_double("orders") }
  let(:parameters) { { order: { card_token: token } } }

  before do
    allow(user).to receive(:orders).and_return(orders)
    allow(order).to receive(:discount=)
    allow(order).to receive(:save_with_charge).and_return(true)
    allow(orders).to receive(:build).and_return(order)
    allow(subject).to receive(:current_user).and_return(user)

    post :create, parameters
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#create, with a discount" do
  let(:user)       { build_stubbed(:user) }
  let(:order)      { build_stubbed(:order, user: user) }
  let(:discount)   { create(:discount) }
  let(:token)      { "tok_1234" }
  let(:orders)     { instance_double("orders") }
  let(:parameters) { { order: { card_token: token } } }

  before do
    allow(user).to receive(:orders).and_return(orders)
    allow(order).to receive(:discount=)
    allow(order).to receive(:save_with_charge).and_return(true)
    allow(orders).to receive(:build).and_return(order)
    allow(subject).to receive(:current_user).and_return(user)

    session[:discount_id] = discount.id

    post :create, parameters
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#create, with an invalid order" do
  let(:user)       { build_stubbed(:user) }
  let(:order)      { build(:order, user: user, email: "") }
  let(:token)      { "tok_1234" }
  let(:orders)     { instance_double("orders") }
  let(:parameters) { { order: { card_token: token, email: "" } } }

  before do
    allow(user).to receive(:orders).and_return(orders)
    allow(orders).to receive(:build).and_return(order)
    allow(subject).to receive(:current_user).and_return(user)

    post :create, parameters
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#create, with a Stripe error" do
  let(:user)       { build_stubbed(:user) }
  let(:order)      { build_stubbed(:order, user: user) }
  let(:token)      { "tok_1234" }
  let(:orders)     { instance_double("orders") }
  let(:exception)  { Stripe::StripeError.new("Invalid card.") }
  let(:parameters) { { order: { card_token: token } } }

  before do
    allow(user).to receive(:orders).and_return(orders)
    allow(order).to receive(:save_with_charge).and_raise(exception)
    allow(orders).to receive(:build).and_return(order)
    allow(subject).to receive(:current_user).and_return(user)

    post :create, parameters
  end

  it { should redirect_to(root_path) }
end

describe OrderController, "#create, when signed out" do
  before do
    allow(subject).to receive(:signed_in?).and_return(false)

    post :create
  end

  it { should redirect_to(root_path) }
end
