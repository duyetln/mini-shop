require 'spec_setup'
require 'spec/models/service_resource'

describe Address do
  include_examples 'service resource'
  include_examples 'default update'
end
