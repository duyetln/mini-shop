class CreateCouponsTable < ActiveRecord::Migration
  def up
    create_table :coupons do |t|
      t.string   :code
      t.integer  :batch_id
      t.integer  :used_by
      t.datetime :used_at
      t.datetime :created_at
    end

    add_index    :coupons, :code
    add_index    :coupons, :used_by
    add_index    :coupons, :batch_id
  end

  def down
    remove_index :coupons, :batch_id
    remove_index :coupons, :used_by
    remove_index :coupons, :code
    drop_table   :coupons
  end
end
