class AddBillingAddressIdToPaymentMethods < ActiveRecord::Migration
  def up
    add_column :payment_methods, :billing_address_id, :integer
    remove_column :purchases, :billing_address_id
    remove_column :transactions, :billing_address_id
  end

  def down
    add_column :transactions, :billing_address_id, :integer
    add_column :purchases, :billing_address_id, :integer
    remove_column :payment_methods, :billing_address_id
  end
end
