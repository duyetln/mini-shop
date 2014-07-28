require 'lib/base'

module BackendClient
  class Purchase < Base
    include DefaultFind
    include DefaultUpdate

    def self.instantiate(hash = {})
      super do |purchase|
        purchase.payment_method = PaymentMethod.instantiate(purchase.payment_method)
        purchase.billing_address = Address.instantiate(purchase.billing_address)
        purchase.shipping_address = Address.instantiate(purchase.shipping_address)
        purchase.payment = Transaction.instantiate(purchase.payment)
        purchase.orders.map! { |order| Order.instantiate(order) }
      end
    end

    def add_or_update_order(order = {})
      if order.present?
        catch_error RestClient::UnprocessableEntity do
          fail BackendClient::Errors::Unprocessable.new(
            "Unable to add order to #{humanized_name}",
            "The #{humanized_name} is not allowed for modification currently"
          )
        end
        handle_error do
          self.class.parse(
            self.class.resource["/#{id}/orders"].post Order.params(order)
          ) do |hash|
            load!(hash)
            orders.last
          end
        end
      end
    end

    def delete_order(order_id)
      catch_error RestClient::UnprocessableEntity do
        fail BackendClient::Errors::Unprocessable.new(
          "Unable to remove order from #{humanized_name}",
          "The #{humanized_name} is not allowed for modification currently"
        )
      end
      handle_error do
        self.class.parse(
          self.class.resource["/#{id}/orders/#{order_id}"].delete
        ) do |hash|
          load!(hash)
          orders.count
        end
      end
    end

    def submit!
      catch_error RestClient::BadRequest do
        fail BackendClient::Errors::BadRequest.new(
          "Unable to submit #{humanized_name}",
          (Yajl::Parser.parse(@error.http_body)['message'] rescue nil)
        )
      end
      handle_error do
        self.class.parse(
          self.class.resource["/#{id}/submit"].put({})
        ) do |hash|
          load!(hash)
        end
      end
    end

    def return!
      catch_error RestClient::UnprocessableEntity do
        fail BackendClient::Errors::Unprocessable.new(
          "Unable to return #{humanized_name}",
          "The #{humanized_name} is not submitted or not allowed for return currently"
        )
      end
      handle_error do
        self.class.parse(
          self.class.resource["/#{id}/return"].put({})
        ) do |hash|
          load!(hash)
        end
      end
    end

    def return_order(order_id)
      catch_error RestClient::ResourceNotFound do
        fail BackendClient::Errors::NotFound.new(
          "Unable to return #{Order.humanized_name}",
          "The #{Order.humanized_name} id is invalid"
        )
      end
      catch_error RestClient::UnprocessableEntity do
        fail BackendClient::Errors::Unprocessable.new(
          "Unable to return #{Order.humanized_name}",
          "The #{humanized_name} is not submitted or not allowed for return currently"
        )
      end
      handle_error do
        self.class.parse(
          self.class.resource["/#{id}/orders/#{order_id}/return"].put({})
        ) do |hash|
          load!(hash)
          orders.find { |order| order.id == order_id }
        end
      end
    end
  end
end
