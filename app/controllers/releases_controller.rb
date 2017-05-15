class ReleasesController < ApplicationController
  before_action :verify, only: [:show]

  def index
    @releases = Release.released.ordered_by_version.to_a
  end

  def show
    release = Release.released.find(params[:id])
    url     = release.url(params[:extension])

    redirect_to URI.parse(url).to_s
  end

  protected

  def verify
    redirect_to(root_path) unless current_user.try(:ordered?)
  end
end
