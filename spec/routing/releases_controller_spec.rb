require "rails_helper"

describe ReleasesController do
  it { should route(:get, "/releases").to(action: :index) }
  it { should route(:get, "/releases/1").to(action: :show, id: 1) }
end
