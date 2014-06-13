class UpdateAmountPrecision < ActiveRecord::Migration
  def up
    change_column :discounts, :rate, :decimal, precision: 5, scale: 4
    change_column :orders, :amount, :decimal, precision: 20, scale: 2
    change_column :orders, :tax, :decimal, precision: 20, scale: 2
    change_column :orders, :tax_rate, :decimal, precision: 5, scale: 4
    change_column :payment_methods, :balance, :decimal, precision: 20, scale: 2
    change_column :pricepoint_prices, :amount, :decimal, precision: 20, scale: 2
    change_column :transactions, :amount, :decimal, precision: 20, scale: 2
  end

  def down
    change_column :transactions, :amount, :decimal, precision: 20, scale: 4
    change_column :pricepoint_prices, :amount, :decimal, precision: 20, scale: 4
    change_column :payment_methods, :balance, :decimal, precision: 20, scale: 4
    change_column :orders, :tax_rate, :decimal, precision: 7, scale: 4
    change_column :orders, :tax, :decimal, precision: 20, scale: 4
    change_column :orders, :amount, :decimal, precision: 20, scale: 4
    change_column :discounts, :rate, :decimal, precision: 6, scale: 5
  end
end
