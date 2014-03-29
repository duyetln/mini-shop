require 'spec_helper'
require 'spec/models/shared/item_resource'

describe DigitalItem do

  let(:item_class) { described_class }

  it_behaves_like 'item resource'
end
