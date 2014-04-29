require './boot'

Application.load_lib!
Application.load_models!
Application.load_services!
Application.load_config!

use Rack::Parser, parsers: { 'application/json' => proc { |data| Yajl::Parser.parse data } }

class ApplicationService < Sinatra::Base
  use Services::Base
end

map('/svc') { run ApplicationService }