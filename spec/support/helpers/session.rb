module RSpec
  module Helpers
    module Session
      module Controller
        def sign_in
          sign_in_as create(:user)
        end

        def sign_in_as(user)
          session[:user_id] = user.id
        end
      end

      RSpec.configure do |config|
        config.include Controller, type: :controller
      end
    end
  end
end
