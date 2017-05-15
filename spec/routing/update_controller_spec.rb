require "rails_helper"

describe UpdateController do
  it { should route(:get, "/update/0.1.0").to(action: :show, id: "0.1.0") }
end
