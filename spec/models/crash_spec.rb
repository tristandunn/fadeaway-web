require "rails_helper"

describe Crash do
  it { should belong_to(:user) }

  it { should validate_presence_of(:system) }

  it { should validate_presence_of(:version) }

  it { should allow_value("1.0.0").for(:version) }
  it { should allow_value("0.1.0").for(:version) }
  it { should allow_value("0.0.1").for(:version) }

  it { should_not allow_value("..").for(:version) }
  it { should_not allow_value("1..").for(:version) }
  it { should_not allow_value("1.0.").for(:version) }
  it { should_not allow_value("a.1.0").for(:version) }
  it { should_not allow_value("1.a.0").for(:version) }
  it { should_not allow_value("1.0.a").for(:version) }
end
