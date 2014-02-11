require "spec_helper"
require "item_svc_shared"

describe StorefrontItemsSvc do

  it_behaves_like "item service", StorefrontItem
end