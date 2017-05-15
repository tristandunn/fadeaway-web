require "rails_helper"

describe User do
  before do
    create(:user)
  end

  it { should have_many(:orders) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:remote_id) }
  it { should validate_uniqueness_of(:remote_id) }
  it { should validate_numericality_of(:remote_id).only_integer }
end

describe User, "#ordered?" do
  subject { create(:user) }

  let(:statuses) { Order.statuses }

  it "returns true with a purchased order" do
    create(:order, user: subject, status: statuses[:purchased])

    expect(subject).to be_ordered
  end

  it "returns false with a refunded order" do
    create(:order, user: subject, status: statuses[:refunded])

    expect(subject).not_to be_ordered
  end

  it "returns false without an order" do
    expect(subject).not_to be_ordered
  end
end
