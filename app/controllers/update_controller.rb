class UpdateController < ApplicationController
  def show
    version = Version.new(params[:id])

    if version < Version.new(release.version)
      render json: {
        url:   url,
        name:  name,
        notes: notes
      }
    else
      head :no_content
    end
  end

  protected

  def name
    release.version.to_s
  end

  def notes
    render_to_string collection: Release.since(params[:id]),
                     partial:    "releases/release.html",
                     locals:     { client: true }
  end

  def release
    @release ||= Release.latest
  end

  def url
    release_url release, access_token: params[:access_token]
  end
end
