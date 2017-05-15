module Administration
  class ApplicationController < Administrate::ApplicationController
    include Authentication

    before_action :authenticate

    protected

    def authenticate
      return if administrator?

      path   = env["PATH_INFO"].inspect
      method = env["REQUEST_METHOD"]

      raise ActionController::RoutingError.new(
        "No route matches [#{method}] #{path}"
      )
    end

    def order
      Administrate::Order.new(params[:order] || :created_at,
                              params[:direction] || :desc)
    end
  end
end
