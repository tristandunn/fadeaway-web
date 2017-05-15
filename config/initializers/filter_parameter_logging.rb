# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :access_token,
  :card_token,
  :code
]
