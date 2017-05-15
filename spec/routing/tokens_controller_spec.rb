require "rails_helper"

describe TokensController do
  it { should route(:post, "/tokens").to(action: :create) }
end
