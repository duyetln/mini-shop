require 'models/shopping/transaction'

class PaymentTransaction < Transaction
  protected

  def process_transaction!
    payment_method.withdraw!(amount, currency)
  end
end
