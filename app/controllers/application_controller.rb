class ApplicationController < ActionController::Base
  include Authentication
  include CurrentDiscount

  protect_from_forgery with: :exception
end
