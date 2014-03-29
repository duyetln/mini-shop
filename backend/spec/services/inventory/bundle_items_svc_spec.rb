require 'spec_helper'
require 'item_svc_helper'

describe BundleItemsSvc do

  let(:key) { :title }
  let(:value) { 'New title' }

  let(:item_class) { BundleItem }

  it_behaves_like 'item service', BundleItem
end