require "spec_helper"
require "item_svc_helper"

describe PhysicalItemsSvc do

  it_behaves_like "item service", PhysicalItem
end