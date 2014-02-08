class CreateDiscountsTable < ActiveRecord::Migration
  def up
    create_table :discounts do |t|
      t.string   :name
      t.decimal  :rate, precision: 6, scale: 5
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :created_at
    end

    add_index    :discounts, :name
  end

  def down
    remove_index :discounts, :name
    drop_table   :discounts
  end
end
