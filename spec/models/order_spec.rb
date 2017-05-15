require "rails_helper"

describe Order do
  subject { create(:order) }

  it { should belong_to(:discount) }
  it { should belong_to(:user) }

  it { should have_many(:refunds) }

  it { should define_enum_for(:status).with([:purchased, :refunded]) }

  it { should validate_numericality_of(:amount).only_integer }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should allow_value("MrBoB@example.com").for(:email) }
  it { should_not allow_value("@.com").for(:email) }

  it { should validate_presence_of(:user_id) }
end

describe Order do
  subject { described_class }

  it "defines a default price" do
    expect(subject::DEFAULT_PRICE).to eq(20_00)
  end
end

describe Order, ".purchased" do
  subject { described_class }

  let(:statuses)   { described_class.statuses }
  let!(:purchased) { create(:order, status: statuses[:purchased]) }
  let!(:refunded)  { create(:order, status: statuses[:refunded]) }

  it "returns only purchased orders" do
    expect(subject.purchased).to eq([purchased])
  end
end

describe Order, "#amount_with_discount" do
  subject { build(:order) }

  let(:amount)   { subject.amount - discount.amount }
  let(:discount) { create(:discount, amount: 3_50) }

  it "returns the default price without a discount" do
    expect(subject.amount_with_discount).to eq(described_class::DEFAULT_PRICE)
  end

  it "returns the default price minus the discount amount with a discount" do
    subject.discount = discount

    expect(subject.amount_with_discount).to eq(amount)
  end
end

describe Order, "#save_with_charge" do
  subject { build(:order) }

  let(:id)     { "ch_1234" }
  let(:amount) { Order::DEFAULT_PRICE - 13_37 }
  let(:charge) { Stripe::Charge.construct_from(id: id, amount: amount) }

  before do
    allow(subject).to receive(:save).and_return(true)
    allow(subject).to receive(:valid?).and_return(true)
    allow(subject).to receive(:amount_with_discount).and_return(amount)
    allow(Stripe::Charge).to receive(:create).and_return(charge)
  end

  it "validates the record" do
    subject.save_with_charge

    expect(subject).to have_received(:valid?).with(no_args)
  end

  it "charges for the order via Stripe" do
    subject.save_with_charge

    expect(Stripe::Charge).to have_received(:create).with(
      amount:        amount,
      source:        subject.card_token,
      currency:      "USD",
      receipt_email: subject.email,
      metadata:      {
        email: subject.email
      }
    )
  end

  it "assigns the charge ID to the order" do
    subject.save_with_charge

    expect(subject.remote_id).to eq(id)
  end

  it "assigns the charge amount to the order" do
    subject.save_with_charge

    expect(subject.amount).to eq(amount)
  end

  it "saves the record" do
    subject.save_with_charge

    expect(subject).to have_received(:save).with(no_args)
  end

  it "returns true" do
    expect(subject.save_with_charge).to eq(true)
  end
end

describe Order, "#save_with_charge, for invalid record" do
  before do
    allow(subject).to receive(:save)
    allow(subject).to receive(:valid?).and_return(false)
    allow(Stripe::Charge).to receive(:create)
  end

  it "validates the record" do
    subject.save_with_charge

    expect(subject).to have_received(:valid?).with(no_args)
  end

  it "does not attempt to save" do
    subject.save_with_charge

    expect(subject).not_to have_received(:save)
  end

  it "does not attempt to charge" do
    subject.save_with_charge

    expect(Stripe::Charge).not_to have_received(:create)
  end

  it "returns false" do
    expect(subject.save_with_charge).to eq(false)
  end
end

describe Order, "#to_transaction" do
  subject { create(:order, discount: discount) }

  let(:discount) { create(:discount, amount: 5_00) }

  it "returns transaction details as JSON for Google Analytics" do
    expect(subject.to_transaction).to eq({
      id:      subject.id.to_s,
      revenue: subject.amount_with_discount / 100
    }.to_json)
  end
end
