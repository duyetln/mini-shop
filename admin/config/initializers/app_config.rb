# cookies serializer
Rails.application.config.action_dispatch.cookies_serializer = :json

# parameter filter
Rails.application.config.filter_parameters += [:password]

# session store
Rails.application.config.session_store :cache_store, key: '_admin_session'

# load dependencies not inferable by autoload or eager loading
require Rails.root.join('lib', 'backend_client')


app_config = YAML.load_file(Rails.root.join('config', 'app_config.yml')).with_indifferent_access
BackendClient.url = app_config[:backend_client][:url]
BackendClient.proxy = app_config[:backend_client][:proxy]
