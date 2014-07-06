require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::Address do
  include_examples 'backend client'
  include_examples 'default update'
end
