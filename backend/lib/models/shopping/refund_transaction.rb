require 'models/shopping/transaction'

class RefundTransaction < Transaction
  protected

  def process_transaction!
    payment_method.deposit!(amount, currency)
  end
end
