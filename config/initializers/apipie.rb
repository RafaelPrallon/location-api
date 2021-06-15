Apipie.configure do |config|
  config.translate = false
  config.default_locale = nil
  config.app_name                = 'LocationApi'
  config.api_base_url            = '/'
  config.doc_base_url            = '/docs'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
