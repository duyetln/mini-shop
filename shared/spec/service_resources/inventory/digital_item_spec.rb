require 'spec_setup'
require 'spec/models/service_resource'

describe DigitalItem do
  include_examples 'service resource'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'
end
