RSpec.configure do |config|
  config.before(:suite) do
    Timecop.freeze
  end

  config.after(:suite) do
    Timecop.return
  end
end
