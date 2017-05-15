class CrashesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    crash = Crash.new(crash_parameters)
    crash.user = current_user if signed_in?
    crash.save

    head :ok
  end

  protected

  def crash_parameters
    {
      version: params[:_version],
      system:  {
        memory_free:  params[:memory_free].to_i,
        memory_total: params[:memory_total].to_i,
        os_arch:      params[:os_arch],
        os_release:   params[:os_release]
      }
    }
  end
end
