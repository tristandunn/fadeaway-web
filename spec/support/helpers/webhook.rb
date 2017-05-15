module RSpec
  module Helpers
    module Webhook
      def build_event(object = {})
        Stripe::Event.construct_from(data: { object: object })
      end

      def trigger_event(type, event)
        ActiveSupport::Notifications.instrument(type, event)
      end
    end

    RSpec.configure do |config|
      config.include Webhook, described_class: ::Webhook
    end
  end
end
