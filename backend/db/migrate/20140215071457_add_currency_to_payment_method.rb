class AddCurrencyToPaymentMethod < ActiveRecord::Migration
  def change
    add_column :payment_methods, :currency_id, :integer
  end
end
