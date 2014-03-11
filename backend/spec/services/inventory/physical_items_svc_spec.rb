require "spec_helper"
require "item_svc_helper"

describe PhysicalItemsSvc do

  let(:key) { :title }
  let(:value) { "New title" }

  it_behaves_like "item service", PhysicalItem
end