require "spec_helper"
require "item_svc_shared"

describe DigitalItemsSvc do

  it_behaves_like "item service", DigitalItem
end