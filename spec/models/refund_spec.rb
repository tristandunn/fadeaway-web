require "rails_helper"

describe Refund do
  it { should belong_to(:order) }

  it { should validate_presence_of(:remote_id) }

  it { should validate_presence_of(:created_at) }

  it do
    should validate_numericality_of(:amount).only_integer.is_greater_than(0)
  end
end
