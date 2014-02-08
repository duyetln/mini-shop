class CreateAddressesTable < ActiveRecord::Migration
  def up
    create_table :addresses do |t|
      t.integer  :user_id
      t.string   :line1
      t.string   :line2
      t.string   :line3
      t.string   :city
      t.string   :region
      t.string   :postal_code
      t.string   :country
    end

    add_index    :addresses, :user_id
  end

  def down
    remove_index :addresses, :user_id
    drop_table   :addresses
  end
end
