require 'spec_setup'
require 'spec/base'

describe BackendClient::DigitalItem do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'
end
