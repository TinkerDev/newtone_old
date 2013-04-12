Airbrake.configure do |config|
  config.api_key = '1640141aada40cfbaf69f15b9720ea6e'
  config.host    = 'errbit.brandymint.ru'
  config.port    = 80
  config.secure  = config.port == 443
end