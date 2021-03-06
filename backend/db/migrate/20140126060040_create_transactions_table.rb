class CreateTransactionsTable < ActiveRecord::Migration
  def up
    create_table :transactions do |t|
      t.string   :uuid
      t.integer  :user_id
      t.integer  :payment_method_id
      t.integer  :billing_address_id
      t.decimal  :amount, precision: 20, scale: 4
      t.integer  :currency_id
      t.boolean  :committed
      t.datetime :committed_at
      t.datetime :created_at
    end

    add_index    :transactions, :user_id
  end

  def down
    remove_index :transactions, :user_id
    drop_table   :transactions
  end
end
