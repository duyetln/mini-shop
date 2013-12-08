require "./boot"

use Rack::Parser, parsers: { 'application/json' => proc { |data| Yajl::Parser.parse data } }

class ApplicationService < Sinatra::Base;  end

map("/svc") { run ApplicationService }