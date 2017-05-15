require "rails_helper"

describe Administration::UsersController do
  subject { described_class }

  it "inherits from Administration::ApplicationController" do
    expect(subject.superclass).to eq(Administration::ApplicationController)
  end
end
