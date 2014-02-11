require "spec_helper"
require "item_svc_shared"

describe BundleItemsSvc do

  it_behaves_like "item service", BundleItem
end