require "rails_helper"

describe OrderController do
  it { should route(:get,  "/order").to(action: :index) }
  it { should route(:get,  "/order/new").to(action: :new) }
  it { should route(:post, "/order").to(action: :create) }
end
