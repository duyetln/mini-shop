require 'lib/base'

module BackendClient
  class User < Base
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate

    [:ownerships, :shipments, :coupons, :transactions, :orders, :purchases].each do |association|
      define_method "#{association}" do
        klass = BackendClient.const_get(association.to_s.classify)
        self.class.parse(
          self.class.resource["/#{id}/#{association}"].get
        ).map do |hash|
          klass.instantiate(hash)
        end
      end
    end

    [:purchase, :address, :payment_method].each do |association|
      define_method "create_#{association}" do |object = {}|
        if object.present?
          klass = BackendClient.const_get(association.to_s.classify)
          self.class.parse(
            self.class.resource["/#{id}/#{association.to_s.pluralize}"].post klass.params(object)
          ) do |hash|
            klass.instantiate(hash)
          end
        end
      end
    end

    def self.instantiate(hash = {})
      super do |user|
        user.addresses.map! { |address| Address.instantiate(address) }
        user.payment_methods.map! { |payment_method| PaymentMethod.instantiate(payment_method) }
      end
    end

    def self.authenticate(email, password)
      catch_error RestClient::Unauthorized, RestClient::ResourceNotFound do
        fail BackendClient::Errors::Unauthorized.new(
          "Unable to authenticate #{humanized_name}",
          'Email or password is invalid'
        )
      end
      handle_error do
        parse(resource['/authenticate'].post params(email: email, password: password)) do |hash|
          instantiate(hash)
        end
      end
    end

    def self.confirm(uuid, actv_code)
      catch_error RestClient::ResourceNotFound do
        fail BackendClient::Errors::NotFound.new(
          "Unable to confirm #{humanized_name}",
          'Activation code is invalid'
        )
      end
      handle_error do
        parse(resource["/#{uuid}/confirm/#{actv_code}"].put({})) do |hash|
          instantiate(hash)
        end
      end
    end
  end
end
