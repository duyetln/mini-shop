require 'backend_client/concerns/errors'
require 'backend_client/concerns/method_access'
require 'backend_client/concerns/api_resource'
require 'backend_client/concerns/api_model'
require 'backend_client/concerns/all'
require 'backend_client/concerns/find'
require 'backend_client/concerns/create'
require 'backend_client/concerns/update'
require 'backend_client/concerns/activate'
require 'backend_client/concerns/delete'

require 'backend_client/fulfillment/ownership'
require 'backend_client/fulfillment/shipment'

require 'backend_client/shared/status'
require 'backend_client/shared/spec'

require 'backend_client/accounts/user'
require 'backend_client/mailing/email'

require 'backend_client/inventory/currency'
require 'backend_client/inventory/pricepoint_price'
require 'backend_client/inventory/pricepoint'
require 'backend_client/inventory/discount'
require 'backend_client/inventory/price'
require 'backend_client/inventory/digital_item'
require 'backend_client/inventory/physical_item'
require 'backend_client/inventory/bundled'
require 'backend_client/inventory/bundle'
require 'backend_client/inventory/store_item'
require 'backend_client/inventory/coupon'
require 'backend_client/inventory/batch'
require 'backend_client/inventory/promotion'

require 'backend_client/shopping/address'
require 'backend_client/shopping/payment_method'
require 'backend_client/shopping/transaction'
require 'backend_client/shopping/payment_transaction'
require 'backend_client/shopping/refund_transaction'
require 'backend_client/shopping/order'
require 'backend_client/shopping/purchase'

module BackendClient
  class << self
    attr_accessor :url

    def proxy=(proxy)
      RestClient.proxy = proxy
    end

    def proxy
      RestClient.proxy
    end
  end
end
