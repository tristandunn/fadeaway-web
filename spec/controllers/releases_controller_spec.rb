require "rails_helper"

describe ReleasesController, "#index" do
  before do
    create(:release, released_at: nil)
    create_list(:release, 3)

    get :index
  end

  it { should render_template(:index) }

  it "renders the released releases" do
    expect(response.body).to have_css("article", count: 3)
  end
end

describe ReleasesController, "#show" do
  let(:user)    { order.user }
  let(:order)   { create(:order) }
  let(:release) { create(:release) }

  before do
    sign_in_as(user)

    get :show, id: release.id
  end

  it { should redirect_to(release.url) }
end

describe ReleasesController, "#show, as a DMG" do
  let(:user)    { order.user }
  let(:order)   { create(:order) }
  let(:release) { create(:release) }

  before do
    sign_in_as(user)

    get :show, id: release.id, extension: :dmg
  end

  it { should redirect_to(release.url(:dmg)) }
end

describe ReleasesController, "#show, with an unreleased release" do
  let(:user)    { order.user }
  let(:order)   { create(:order) }
  let(:release) { create(:release, released_at: nil) }

  before do
    sign_in_as(user)
  end

  it "does not find the release" do
    expect do
      get :show, id: release.id
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end

describe ReleasesController, "#show, without an order" do
  let(:user)    { create(:user) }
  let(:release) { create(:release) }

  before do
    sign_in_as(user)

    get :show, id: release.id
  end

  it { should redirect_to(root_path) }
end

describe ReleasesController, "#show, signed out" do
  let(:release) { create(:release) }

  before do
    get :show, id: release.id
  end

  it { should redirect_to(root_path) }
end
