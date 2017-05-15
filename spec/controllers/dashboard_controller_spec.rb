require "rails_helper"

describe DashboardController, "#index" do
  let(:order)   { create(:order) }
  let(:release) { create(:release) }
  let(:support) { "hello@tristandunn.com" }

  before do
    sign_in_as order.user

    allow(Release).to receive(:latest).and_return(release)

    get :index
  end

  it { should respond_with(200) }
  it { should render_template(:index) }

  it "finds the latest release" do
    expect(Release).to have_received(:latest)
  end

  it "links to the release download" do
    url = release_path(release, extension: :dmg)

    expect(response.body).to have_css(%(a[href="#{url}"]),
                                      text: "Download v#{release.version}")
  end

  it "renders the release notes" do
    expect(response.body).to have_content(release.description)
  end

  it "links to support" do
    expect(response.body).to have_css(%(a[href="mailto:#{support}"]),
                                      text: support)
  end

  it "does not Google Analytics tracking" do
    expect(response.body).not_to have_content(%(
      ga("ecommerce:addTransaction", #{order.to_transaction});
    ))
  end
end

describe DashboardController, "#index, with tracking" do
  let(:order)   { create(:order) }
  let(:release) { create(:release) }

  before do
    sign_in_as order.user

    allow(Release).to receive(:latest).and_return(release)
    allow(subject).to receive(:flash).and_return(track: true)

    get :index
  end

  it { should respond_with(200) }
  it { should render_template(:index) }

  it "renders Google Analytics tracking" do
    expect(response.body).to have_content(%(
      ga("ecommerce:addTransaction", #{order.to_transaction});
    ))
  end
end

describe DashboardController, "#index, for a user without an order" do
  before do
    sign_in

    get :index
  end

  it { should redirect_to(new_order_path) }
end

describe DashboardController, "#index, signed out" do
  before do
    get :index
  end

  it { should redirect_to(Token.authorize_url) }
end
