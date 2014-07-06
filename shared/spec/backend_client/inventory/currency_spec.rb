require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::Currency do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default create'
end
