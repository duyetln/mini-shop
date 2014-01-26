class CreatePaymentMethodsTable < ActiveRecord::Migration
  def up
    create_table :payment_methods do |t|
      t.integer  :user_id
      t.string   :name
      t.decimal  :balance, precision: 20, scale: 4
      t.datetime :created_at
    end

    add_index    :payment_methods, :user_id
  end

  def down
    remove_index :payment_methods, :user_id
    drop_table   :payment_methods
  end
end
