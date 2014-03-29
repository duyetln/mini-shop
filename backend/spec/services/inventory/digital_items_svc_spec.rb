require 'spec_helper'
require 'item_svc_helper'

describe DigitalItemsSvc do

  let(:key) { :title }
  let(:value) { 'New title' }

  let(:item_class) { DigitalItem }

  it_behaves_like 'item service', DigitalItem
end