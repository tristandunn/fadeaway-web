require "rails_helper"

describe Webhook, "#initialize" do
  subject { described_class.new(id) }

  let(:id) { "1234" }

  it "assigns the ID provided" do
    expect(subject.id).to eq(id)
  end
end

describe Webhook, ".subscribe" do
  subject { described_class }

  let(:name)      { "test.event" }
  let(:data)      { instance_double("data", object: object) }
  let(:event)     { instance_double("event", payload: payload) }
  let(:object)    { instance_double("object") }
  let(:payload)   { instance_double("payload", data: data) }
  let(:arguments) { [1, 2, 3, 4, 5] }

  before do
    allow(ActiveSupport::Notifications).to receive(:subscribe)
      .and_yield(*arguments)
    allow(ActiveSupport::Notifications::Event).to receive(:new)
      .and_return(event)
  end

  it "subscribes to the event" do
    subject.subscribe(name) {}

    expect(ActiveSupport::Notifications).to have_received(:subscribe).with(name)
  end

  it "creates an events from the notification arguments" do
    subject.subscribe(name) {}

    expect(ActiveSupport::Notifications::Event).to have_received(:new)
      .with(*arguments)
  end

  it "yields the event and object" do
    yielded = nil

    subject.subscribe(name) do |*arguments|
      yielded = arguments
    end

    expect(yielded).to eq([event, object])
  end
end

describe Webhook, "#event" do
  subject { described_class.new(id) }

  let(:id)    { "1234" }
  let(:event) { instance_double("event") }

  before do
    allow(Stripe::Event).to receive(:retrieve).and_return(event)
  end

  it "retrieves the event from Stripe and memoizes it" do
    subject.event
    subject.event

    expect(Stripe::Event).to have_received(:retrieve).with(id).once
  end

  it "returns the event" do
    expect(subject.event).to eq(event)
  end
end

describe Webhook, "#instrument" do
  subject { described_class.new("1234") }

  let(:type)  { "test.event" }
  let(:event) { instance_double("event", type: type) }

  before do
    allow(subject).to receive(:event).and_return(event)

    allow(ActiveSupport::Notifications).to receive(:instrument)
  end

  it "instruments the event" do
    subject.instrument

    expect(ActiveSupport::Notifications).to have_received(:instrument)
      .with(type, event).once
  end
end
