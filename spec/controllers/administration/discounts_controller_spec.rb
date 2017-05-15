require "rails_helper"

describe Administration::DiscountsController do
  subject { described_class }

  it "inherits from Administration::ApplicationController" do
    expect(subject.superclass).to eq(Administration::ApplicationController)
  end
end

describe Administration::DiscountsController, "#order" do
  before do
    allow(subject).to receive(:params).and_return({})
    allow(Administrate::Order).to receive(:new)
  end

  it "defaults to name in ascending order" do
    subject.__send__(:order)

    expect(Administrate::Order).to have_received(:new).with(:name, :asc)
  end
end

describe Administration::DiscountsController, "#order, with parameters" do
  let(:order)     { "id" }
  let(:params)    { { order: order, direction: direction } }
  let(:direction) { "desc" }

  before do
    allow(subject).to receive(:params).and_return(params)
    allow(Administrate::Order).to receive(:new)
  end

  it "uses the custom order and direction" do
    subject.__send__(:order)

    expect(Administrate::Order).to have_received(:new).with(order, direction)
  end
end
