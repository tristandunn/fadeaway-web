require "rails_helper"

describe PagesController, "#index" do
  before do
    get :index
  end

  it { should respond_with(200) }
  it { should render_template(:index) }

  it "does not display a discount" do
    expect(response.body).not_to have_css(".discount-designer-news")
    expect(response.body).not_to have_css(".discount-dribbble")
    expect(response.body).not_to have_css(".discount-product-hunt")
  end
end

describe PagesController, "#index, from Designer News" do
  let!(:discount) { create(:discount, name: "Designer News") }

  before do
    get :index, utm_source: "designernews"
  end

  it "displays Designer News discount" do
    expect(response.body).to have_css(".discount-designer-news")
  end
end

describe PagesController, "#index, from Product Hunt" do
  let!(:discount) { create(:discount, name: "Product Hunt") }

  before do
    get :index, ref: "producthunt"
  end

  it "displays Product Hunt discount" do
    expect(response.body).to have_css(".discount-product-hunt")
  end
end

describe PagesController, "#index, when signed in" do
  before do
    sign_in

    get :index
  end

  it "displays a sign out button in the header" do
    expect(response.body).to have_css(".header button", text: "Sign Out")
  end

  it "does not display a link to the dashboard in the header" do
    expect(response.body).not_to have_css(".header a", text: "Dashboard")
  end

  it "does not display a link to the administration in the header" do
    expect(response.body).not_to have_css(".header a", text: "Administration")
  end

  it "does not display a sign in link in the header" do
    expect(response.body).not_to have_css(".header a", text: "Sign In")
  end
end

describe PagesController, "#index, when signed in and purchased" do
  let(:order) { create(:order) }

  before do
    sign_in_as order.user

    get :index
  end

  it "displays a link to the dashboard in the header" do
    expect(response.body).to have_css(".header a", text: "Dashboard")
  end

  it "displays a sign out button in the header" do
    expect(response.body).to have_css(".header button", text: "Sign Out")
  end

  it "does not display a link to the administration in the header" do
    expect(response.body).not_to have_css(".header a", text: "Administration")
  end

  it "does not display a sign in link in the header" do
    expect(response.body).not_to have_css(".header a", text: "Sign In")
  end
end

describe PagesController, "#index, when signed in as an administrator" do
  let(:user) { create(:user, remote_id: Authentication::ADMINISTRATORS.first) }

  before do
    sign_in_as user

    get :index
  end

  it "displays a sign out button in the header" do
    expect(response.body).to have_css(".header button", text: "Sign Out")
  end

  it "displays a link to the administration in the header" do
    expect(response.body).to have_css(".header a", text: "Administration")
  end

  it "does not display a link to the dashboard in the header" do
    expect(response.body).not_to have_css(".header a", text: "Dashboard")
  end

  it "does not display a sign in link in the header" do
    expect(response.body).not_to have_css(".header a", text: "Sign In")
  end
end

describe PagesController, "#index, when signed out" do
  before do
    get :index
  end

  it "displays a sign in link in the header" do
    expect(response.body).to have_css(".header a", text: "Sign In")
  end

  it "does not display a link to the administration in the header" do
    expect(response.body).not_to have_css(".header a", text: "Administration")
  end

  it "does not display a link to the dashboard in the header" do
    expect(response.body).not_to have_css(".header a", text: "Dashboard")
  end

  it "does not display a sign out button in the header" do
    expect(response.body).not_to have_css(".header button", text: "Sign Out")
  end
end

describe PagesController, "#privacy" do
  before do
    get :privacy
  end

  it { should respond_with(200) }
  it { should render_template(:privacy) }
end

describe PagesController, "#refunds" do
  before do
    get :refunds
  end

  it { should respond_with(200) }
  it { should render_template(:refunds) }
end

describe PagesController, "#sketch" do
  before do
    get :sketch
  end

  it "displays a link to purchase" do
    expect(response.body).to have_css(%(a[href="#{order_index_path}"]),
                                      text: "Buy Now for $20")
  end
end

describe PagesController, "#sketch, when signed in" do
  before do
    sign_in

    get :sketch
  end

  it "displays a link to purchase" do
    expect(response.body).to have_css(%(a[href="#{order_index_path}"]),
                                      text: "Buy Now for $20")
  end
end

describe PagesController, "#sketch, when signed in and purchased" do
  let(:order)    { create(:order) }
  let!(:release) { create(:release) }

  before do
    sign_in_as order.user

    get :sketch
  end

  it "displays how to install the Sketch plugin" do
    expect(response.body).to have_content(
      "You can install the plugin from the preference window."
    )
  end
end

describe PagesController, "#terms" do
  before do
    get :terms
  end

  it { should respond_with(200) }
  it { should render_template(:terms) }
end
