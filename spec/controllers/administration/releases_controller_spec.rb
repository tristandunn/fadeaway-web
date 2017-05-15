require "rails_helper"

describe Administration::ReleasesController do
  subject { described_class }

  it "inherits from Administration::ApplicationController" do
    expect(subject.superclass).to eq(Administration::ApplicationController)
  end
end

describe Administration::ReleasesController, "#resource_params" do
  let(:logs) { { "added" => ["Example item."] } }
  let(:parameters) do
    ActionController::Parameters.new(release: { logs: logs.to_s })
  end

  before do
    allow(subject).to receive(:params).and_return(parameters)
  end

  it "converts the logs from JSON" do
    expect(subject.__send__(:resource_params)).to eq("logs" => logs)
  end
end

describe Administration::ReleasesController, "#resource_params, with no logs" do
  let(:parameters) do
    ActionController::Parameters.new(release: { logs: "" })
  end

  before do
    allow(subject).to receive(:params).and_return(parameters)
  end

  it "does not convert the logs" do
    expect { subject.__send__(:resource_params) }.not_to raise_error
  end
end
