class CreatePricepointPricesTable < ActiveRecord::Migration
  def up
    create_table :pricepoint_prices do |t|
      t.decimal  :amount, precision: 20, scale: 4
      t.integer  :pricepoint_id
      t.integer  :currency_id
    end

    add_index    :pricepoint_prices, :pricepoint_id
    add_index    :pricepoint_prices, :currency_id
  end

  def down
    remove_index :pricepoint_prices, :currency_id
    remove_index :pricepoint_prices, :pricepoint_id
    drop_table   :pricepoint_prices
  end
end
