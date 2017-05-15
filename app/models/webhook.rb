class Webhook
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def event
    @event ||= Stripe::Event.retrieve(id)
  end

  def instrument
    ActiveSupport::Notifications.instrument(event.type, event)
  end

  def self.subscribe(name, &_block)
    ActiveSupport::Notifications.subscribe(name) do |*arguments|
      event  = ActiveSupport::Notifications::Event.new(*arguments)
      object = event.payload.data.object

      yield event, object
    end
  end
end

# Require webhook subscriptions, since they are not autoloaded classes.
Dir[Rails.root.join("app/models/webhook/*.rb")].each do |file|
  require file
end
