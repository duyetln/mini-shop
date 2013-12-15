require "./boot"

use Rack::Parser, parsers: { 'application/json' => proc { |data| Yajl::Parser.parse data } }

class ApplicationService < Sinatra::Base
  use PhysicalSkusService
  use DigitalSkusService
  use BundleSkusService
  use StorefrontSkusService
end

map("/svc") { run ApplicationService }