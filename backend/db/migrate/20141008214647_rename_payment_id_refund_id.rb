class RenamePaymentIdRefundId < ActiveRecord::Migration
  def change
    rename_column :purchases, :payment_id, :payment_transaction_id
    rename_column :orders, :refund_id, :refund_transaction_id
  end
end
