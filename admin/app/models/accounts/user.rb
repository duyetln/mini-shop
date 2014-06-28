class User < ServiceResource
  extend DefaultCreate
  extend DefaultFind
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |user|
      user.addresses.map! { |address| Address.instantiate(address) }
      user.payment_methods.map! { |payment_method| PaymentMethod.instantiate(payment_method) }
    end
  end
end
