require "rails_helper"

describe Administration::ApplicationController, "#authenticate" do
  before do
    allow(subject).to receive(:redirect_to)
  end

  it "does not redirect to root URL for an administrator" do
    allow(subject).to receive(:administrator?).and_return(true)

    expect do
      subject.__send__(:authenticate)
    end.not_to raise_error
  end

  it "redirects to root URL for an non-administrator" do
    allow(subject).to receive(:administrator?).and_return(false)

    expect do
      subject.__send__(:authenticate)
    end.to raise_error(ActionController::RoutingError)
  end
end

describe Administration::ApplicationController, "#order" do
  before do
    allow(subject).to receive(:params).and_return({})
    allow(Administrate::Order).to receive(:new)
  end

  it "defaults to created_at in descending order" do
    subject.__send__(:order)

    expect(Administrate::Order).to have_received(:new).with(:created_at, :desc)
  end
end

describe Administration::ApplicationController, "#order, with parameters" do
  let(:order)     { "id" }
  let(:params)    { { order: order, direction: direction } }
  let(:direction) { "asc" }

  before do
    allow(subject).to receive(:params).and_return(params)
    allow(Administrate::Order).to receive(:new)
  end

  it "uses the custom order and direction" do
    subject.__send__(:order)

    expect(Administrate::Order).to have_received(:new).with(order, direction)
  end
end
