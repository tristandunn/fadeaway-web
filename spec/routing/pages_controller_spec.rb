require "rails_helper"

describe PagesController do
  it { should route(:get, "/").to(action: :index) }
  it { should route(:get, "/privacy").to(action: :privacy) }
  it { should route(:get, "/refunds").to(action: :refunds) }
  it { should route(:get, "/sketch").to(action: :sketch) }
  it { should route(:get, "/terms").to(action: :terms) }
end
