module BackendClient
  class User < APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate

    [:ownerships, :shipments, :coupons, :transactions, :orders, :purchases].each do |association|
      define_method "#{association}" do
        klass = BackendClient.const_get(association.to_s.classify)
        self.class.get(
          path: "/#{id}/#{association}"
        ).map do |hash|
          klass.new(hash)
        end
      end
    end

    [:purchase, :address, :payment_method].each do |association|
      define_method "create_#{association}" do |object = {}|
        if object.present?
          klass = BackendClient.const_get(association.to_s.classify)
          self.class.post(
            path: "/#{id}/#{association.to_s.pluralize}",
            payload: klass.params(object)
          ) do |hash|
            klass.new(hash)
          end
        end
      end
    end

    def self.build_attributes(hash = {})
      super do |user|
        user.addresses.map! { |address| Address.new(address) }
        user.payment_methods.map! { |payment_method| PaymentMethod.new(payment_method) }
      end
    end

    def self.authenticate(email, password)
      new(post(path: '/authenticate', payload: params(email: email, password: password)))
    end

    def self.confirm(uuid, actv_code)
      new(put path: "/#{uuid}/confirm/#{actv_code}")
    end
  end
end
