require 'spec_setup'

describe BackendClient::DigitalItem do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'
end
