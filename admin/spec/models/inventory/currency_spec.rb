require 'spec_setup'
require 'spec/models/service_resource'

describe Currency do
  include_examples 'service resource'
  include_examples 'default all'
  include_examples 'default create'
end
