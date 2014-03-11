require "spec_helper"
require "item_svc_helper"

describe StorefrontItemsSvc do

  let(:key) { :name }
  let(:value) { "New name" }

  it_behaves_like "item service", StorefrontItem
end