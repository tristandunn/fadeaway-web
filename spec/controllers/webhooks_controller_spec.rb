require "rails_helper"

describe WebhooksController, "#create, successfully" do
  let(:id)    { "1234" }
  let(:event) { instance_double(Webhook, instrument: true) }

  before do
    allow(Webhook).to receive(:new).and_return(event)

    post :create, id: id
  end

  it { should respond_with(200) }

  it "creates a webhook" do
    expect(Webhook).to have_received(:new).with(id).once
  end

  it "instruments the webhook" do
    expect(event).to have_received(:instrument).once
  end
end

describe WebhooksController, "#create, with a Stripe error" do
  let(:id)    { "1234" }
  let(:event) { instance_double(Webhook) }

  before do
    allow(Webhook).to receive(:new).and_return(event)
    allow(event).to receive(:instrument).and_raise(Stripe::StripeError)

    post :create, id: id
  end

  it { should respond_with(400) }
end
