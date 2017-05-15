require "rails_helper"

describe DashboardController do
  it { should route(:get, "/dashboard").to(action: :index) }
end
