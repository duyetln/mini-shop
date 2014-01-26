class CreatePaymentsTable < ActiveRecord::Migration
  def up
    create_table :payments do |t|
      t.string   :uuid
      t.integer  :user_id
      t.integer  :payment_method_id
      t.integer  :billing_address_id
      t.decimal  :amount, precision: 20, scale: 4
      t.integer  :currency_id
      t.boolean  :refunded
      t.datetime :created_at
    end

    add_index    :payments, :user_id
  end

  def down
    remove_index :payments, :user_id
    drop_table   :payments
  end
end
