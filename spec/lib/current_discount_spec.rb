require "rails_helper"

class ExampleController < ActionController::Base
  include CurrentDiscount
end

describe CurrentDiscount, "#current_discount, with a discount loaded" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }

  before do
    allow(subject).to receive(:discount_from_session)
    allow(subject).to receive(:discount_from_source)

    subject.instance_variable_set("@current_discount", discount)
  end

  it "does not attempt to load a discount from the session" do
    subject.current_discount

    expect(subject).not_to have_received(:discount_from_session)
  end

  it "does not attempt to load a discount from the source" do
    subject.current_discount

    expect(subject).not_to have_received(:discount_from_source)
  end

  it "returns the discount" do
    expect(subject.current_discount).to eq(discount)
  end
end

describe CurrentDiscount, "#current_discount, with a discount in the session" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }

  before do
    allow(subject).to receive(:discount_from_session).and_return(discount)
    allow(subject).to receive(:discount_from_source).and_return(nil)
  end

  it "loads the discount from the session" do
    subject.current_discount

    expect(subject).to have_received(:discount_from_session)
  end

  it "assigns the discount to the instance variable" do
    subject.current_discount

    expect(subject.instance_variable_get("@current_discount")).to eq(discount)
  end

  it "returns the discount" do
    expect(subject.current_discount).to eq(discount)
  end
end

describe CurrentDiscount, "#current_discount, with a discount from a source" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }

  before do
    allow(subject).to receive(:discount_from_session).and_return(nil)
    allow(subject).to receive(:discount_from_source).and_return(discount)
  end

  it "attempts to load the discount from the session" do
    subject.current_discount

    expect(subject).to have_received(:discount_from_session)
  end

  it "loads the discount from the source" do
    subject.current_discount

    expect(subject).to have_received(:discount_from_source)
  end

  it "assigns the discount to the instance variable" do
    subject.current_discount

    expect(subject.instance_variable_get("@current_discount")).to eq(discount)
  end

  it "returns the discount" do
    expect(subject.current_discount).to eq(discount)
  end
end

describe CurrentDiscount, "#current_discount, with no discount in session" do
  subject { ExampleController.new }

  before do
    allow(subject).to receive(:discount_from_session).and_return(nil)
    allow(subject).to receive(:discount_from_source).and_return(nil)
  end

  it "attempts to load a discount from the session" do
    subject.current_discount

    expect(subject).to have_received(:discount_from_session)
  end

  it "assigns nil to the instance variable" do
    subject.current_discount

    expect(subject.instance_variable_get("@current_discount")).to eq(nil)
  end

  it "returns nil" do
    expect(subject.current_discount).to eq(nil)
  end
end

describe CurrentDiscount, "#current_discount=, assigned a discount" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }
  let(:session)  { {} }

  before do
    allow(subject).to receive(:session).and_return(session)

    subject.current_discount = discount
  end

  it "assigns the discount ID to the session" do
    expect(subject.session[:discount_id]).to eq(discount.id)
  end

  it "assigns the discount to the instance variable" do
    expect(subject.instance_variable_get("@current_discount")).to eq(discount)
  end
end

describe CurrentDiscount, "#current_discount=, when not assigned a discount" do
  subject { ExampleController.new }

  let(:session) { {} }

  before do
    allow(subject).to receive(:session).and_return(session)

    subject.current_discount = false
  end

  it "assigns nil to session" do
    expect(subject.session[:discount_id]).to be_nil
  end

  it "assigns nil to instance variable" do
    expect(subject.instance_variable_get("@current_discount")).to be_nil
  end
end

describe CurrentDiscount, "#discount_from_session, with ID in session" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }
  let(:session)  { { discount_id: discount.id } }

  before do
    allow(subject).to receive(:current_discount=)
    allow(subject).to receive(:session).and_return(session)

    allow(Discount).to receive(:find_by).and_return(discount)
  end

  it "attempts to find the discount" do
    subject.discount_from_session

    expect(Discount).to have_received(:find_by).with(id: session[:discount_id])
  end

  it "assigns the discount to current_discount" do
    subject.discount_from_session

    expect(subject).to have_received(:current_discount=).with(discount)
  end

  it "returns the discount" do
    expect(subject.discount_from_session).to eq(discount)
  end
end

describe CurrentDiscount, "#discount_from_session, with no ID in session" do
  subject { ExampleController.new }

  let(:session) { {} }

  before do
    allow(subject).to receive(:current_discount=)
    allow(subject).to receive(:session).and_return(session)

    allow(Discount).to receive(:find_by)
  end

  it "does not attempt to find the discount" do
    subject.discount_from_session

    expect(Discount).not_to have_received(:find_by)
  end

  it "does not assign current_discount" do
    subject.discount_from_session

    expect(subject).not_to have_received(:current_discount=)
  end

  it "returns nil" do
    expect(subject.discount_from_session).to be_nil
  end
end

describe CurrentDiscount, "#discount_from_source, with a utm_source" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }
  let(:params)   { { utm_source: source } }
  let(:source)   { "source_name" }

  before do
    allow(subject).to receive(:current_discount=)
    allow(subject).to receive(:params).and_return(params)

    allow(Discount).to receive(:from_source).and_return(discount)
  end

  it "attempts to find the discount" do
    subject.discount_from_source

    expect(Discount).to have_received(:from_source).with(source)
  end

  it "assigns the discount to current_discount" do
    subject.discount_from_source

    expect(subject).to have_received(:current_discount=).with(discount)
  end

  it "returns the discount" do
    expect(subject.discount_from_source).to eq(discount)
  end
end

describe CurrentDiscount, "#discount_from_source, with a ref" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }
  let(:params)   { { ref: source } }
  let(:source)   { "source_name" }

  before do
    allow(subject).to receive(:current_discount=)
    allow(subject).to receive(:params).and_return(params)

    allow(Discount).to receive(:from_source).and_return(discount)
  end

  it "attempts to find the discount" do
    subject.discount_from_source

    expect(Discount).to have_received(:from_source).with(source)
  end

  it "assigns the discount to current_discount" do
    subject.discount_from_source

    expect(subject).to have_received(:current_discount=).with(discount)
  end

  it "returns the discount" do
    expect(subject.discount_from_source).to eq(discount)
  end
end

describe CurrentDiscount, "#discount_from_source, with no access token" do
  subject { ExampleController.new }

  let(:discount) { build_stubbed(:discount) }
  let(:params)   { {} }

  before do
    allow(subject).to receive(:current_discount=)
    allow(subject).to receive(:params).and_return(params)

    allow(Discount).to receive(:from_source)
  end

  it "does not attempt to find the discount" do
    subject.discount_from_source

    expect(Discount).not_to have_received(:from_source)
  end

  it "does not assign current_discount" do
    subject.discount_from_source

    expect(subject).not_to have_received(:current_discount=)
  end

  it "returns nil" do
    expect(subject.discount_from_source).to be_nil
  end
end
