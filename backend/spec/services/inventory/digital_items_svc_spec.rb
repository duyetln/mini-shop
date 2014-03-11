require "spec_helper"
require "item_svc_helper"

describe DigitalItemsSvc do

  let(:key) { :title }
  let(:value) { "New title" }

  it_behaves_like "item service", DigitalItem
end