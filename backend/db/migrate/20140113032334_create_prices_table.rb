class CreatePricesTable < ActiveRecord::Migration
  def up
    create_table :prices do |t|
      t.string   :name
      t.integer  :pricepoint_id
      t.integer  :discount_id
      t.datetime :created_at
    end

    add_index    :prices, :pricepoint_id
    add_index    :prices, :discount_id
  end

  def down
    remove_index :prices, :discount_id
    remove_index :prices, :pricepoint_id
    drop_table   :prices
  end
end
