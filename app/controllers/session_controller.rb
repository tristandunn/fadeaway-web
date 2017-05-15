class SessionController < ApplicationController
  PROSPECT_TYPE = "Prospect".freeze

  before_action :ignore,            only: [:new], if: :desktop?
  before_action :handle_user_error, only: [:new]
  before_action :handle_prospects,  only: [:new]

  rescue_from OAuth2::Error, with: :handle_server_error

  def new
    user = User.find_or_initialize_by(remote_id: data[:id])
    user.name = data[:name]
    user.save

    self.current_user = user

    redirect_to redirect_path
  end

  def destroy
    session.delete(:user_id)

    redirect_to root_path
  end

  protected

  def code
    params.require(:code)
  end

  def data
    @data ||= begin
                token = Token.create_from_code(:web, code)
                token.get("/v1/user")
              end
  end

  def desktop?
    params[:state] == "desktop"
  end

  def handle_prospects
    if data[:type] == PROSPECT_TYPE
      redirect_to order_index_path, flash: { error: "prospect" }
    end
  end

  def handle_server_error
    redirect_to order_index_path, flash: {
      error: "An error occurred while connecting to Dribbble. Please try again."
    }
  end

  def handle_user_error
    if params[:error].present?
      redirect_to order_index_path, flash: { error: params[:error] }
    end
  end

  def ignore
    head :ok
  end

  def redirect_path
    if current_user.ordered?
      dashboard_index_path
    else
      new_order_path
    end
  end
end
