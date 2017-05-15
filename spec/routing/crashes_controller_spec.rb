require "rails_helper"

describe CrashesController do
  it { should route(:post, "/crashes").to(action: :create) }
end
