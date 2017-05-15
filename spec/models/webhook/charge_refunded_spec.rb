require "rails_helper"

describe Webhook, ".charge_refunded" do
  let(:order)     { create(:order) }
  let(:amount)    { 5_00 }
  let(:created)   { 5.minutes.ago.to_i }
  let(:remote_id) { "re_0500" }

  let(:refunds) do
    { data: [{ id: remote_id, amount: amount, created: created }] }
  end

  let(:event) do
    build_event(id: order.remote_id, amount: amount, refunds: refunds)
  end

  before do
    trigger_event("charge.refunded", event)
  end

  it "does not change the order status to be refunded" do
    expect(order.reload).not_to be_refunded
  end

  it "creates a refund for the order" do
    refund = order.refunds.first

    expect(refund).not_to be_nil
    expect(refund.amount).to eq(amount)
    expect(refund.created_at).to eq(Time.at(created).utc)
  end
end

describe Webhook, ".charge_refunded, for multiple refunds" do
  let(:order)     { create(:order) }
  let(:amount)    { 1_23 }
  let(:refund)    { create(:refund, order: order) }
  let(:created)   { 5.minutes.ago.to_i }
  let(:remote_id) { "re_0500" }

  let(:refunds) do
    {
      data: [
        {
          id:      refund.remote_id,
          amount:  refund.amount,
          created: refund.created_at.to_i
        },
        {
          id:      remote_id,
          amount:  amount,
          created: created
        }
      ]
    }
  end

  let(:event) do
    build_event(id: order.remote_id, amount: amount, refunds: refunds)
  end

  before do
    trigger_event("charge.refunded", event)
  end

  it "does not change the order status to be refunded" do
    expect(order.reload).not_to be_refunded
  end

  it "creates a single new refund for the order" do
    refund = order.refunds.last

    expect(refund).not_to be_nil
    expect(refund.amount).to eq(amount)
    expect(refund.created_at).to eq(Time.at(created).utc)
  end

  it "does not create a duplicate refund" do
    expect(order.refunds.size).to eq(2)
  end
end

describe Webhook, ".charge_refunded, for the full amount" do
  let(:order)     { create(:order) }
  let(:amount)    { order.amount }
  let(:created)   { 5.minutes.ago.to_i }
  let(:remote_id) { "re_0500" }

  let(:refunds) do
    { data: [{ id: remote_id, amount: amount, created: created }] }
  end

  let(:event) do
    build_event(id: order.remote_id, amount: amount, refunds: refunds)
  end

  before do
    trigger_event("charge.refunded", event)
  end

  it "changes the order status to be refunded" do
    expect(order.reload).to be_refunded
  end

  it "creates a refund for the order" do
    refund = order.refunds.first

    expect(refund).not_to be_nil
    expect(refund.amount).to eq(amount)
    expect(refund.created_at).to eq(Time.at(created).utc)
  end
end
