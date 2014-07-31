require 'spec_setup'

describe BackendClient::Currency do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default create'
end
