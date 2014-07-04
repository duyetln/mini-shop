class User < ServiceResource
  extend DefaultAll
  extend DefaultFind
  extend DefaultCreate
  include DefaultUpdate

  [:ownerships, :shipments, :coupons, :transactions, :orders, :purchases].each do |association|
    define_method "#{association}" do
      klass = association.to_s.classify.constantize
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
        klass = association.to_s.classify.constantize
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
    parse(resource['/authenticate'].post params(email: email, password: password)) do |hash|
      instantiate(hash)
    end
  end

  def self.confirm(uuid, actv_code)
    parse(resource["/#{uuid}/confirm/#{actv_code}"].put({})) do |hash|
      instantiate(hash)
    end
  end
end
