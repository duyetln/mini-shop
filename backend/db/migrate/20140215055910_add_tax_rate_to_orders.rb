class AddTaxRateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tax_rate, :decimal, precision: 7, scale: 4
  end
end
