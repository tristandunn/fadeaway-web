require "rails_helper"

describe WebhooksController do
  it { should route(:post, "/webhooks").to(action: :create) }
end
