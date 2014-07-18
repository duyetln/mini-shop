# cookies serializer
Rails.application.config.action_dispatch.cookies_serializer = :json

# parameter filter
Rails.application.config.filter_parameters += [:password]

# session store
Rails.application.config.session_store :cookie_store, key: '_admin_session'

# load dependencies not inferable by autoload or eager loading
Dir[Rails.root.join('lib', '{**/}*rb')].each do |file|
  require file
end

app_config = YAML.load_file(Rails.root.join('config', 'app_config.yml')).with_indifferent_access
BackendClient::ServiceResource.host = app_config[:backend_client][:host]
BackendClient::ServiceResource.proxy = app_config[:backend_client][:proxy]
