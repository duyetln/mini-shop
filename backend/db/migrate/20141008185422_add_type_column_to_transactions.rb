class AddTypeColumnToTransactions < ActiveRecord::Migration
  def up
    add_column :transactions, :type, :string
    Transaction.where('amount >= 0').update_all(type: 'PaymentTransaction')
    Transaction.where('amount < 0').update_all(type: 'RefundTransaction')
    Transaction.where(type: 'RefundTransaction').update_all('amount = ABS(amount)')
  end

  def down
    Transaction.where(type: 'RefundTransaction').update_all('amount = -amount')
    remove_column :transactions, :type
  end
end
