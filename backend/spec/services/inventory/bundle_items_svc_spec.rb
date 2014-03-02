require "spec_helper"
require "item_svc_helper"

describe BundleItemsSvc do

  it_behaves_like "item service", BundleItem
end