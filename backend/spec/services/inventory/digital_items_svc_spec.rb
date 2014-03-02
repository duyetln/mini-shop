require "spec_helper"
require "item_svc_helper"

describe DigitalItemsSvc do

  it_behaves_like "item service", DigitalItem
end