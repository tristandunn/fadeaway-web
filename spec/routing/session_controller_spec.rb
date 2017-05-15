require "rails_helper"

describe SessionController do
  it { should route(:get, "/session/new").to(action: :new) }
  it { should route(:delete, "/session").to(action: :destroy) }
end
