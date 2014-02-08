class CreateBundlingsTable < ActiveRecord::Migration
  def up
    create_table :bundlings do |t|
      t.integer  :bundle_sku_id
      t.integer  :bundled_sku_id
      t.string   :bundled_sku_type
      t.timestamps
    end

    add_index    :bundlings, :bundle_sku_id
    add_index    :bundlings, :bundled_sku_id
    add_index    :bundlings, :bundled_sku_type
  end

  def down
    remove_index :bundlings, :bundled_sku_type
    remove_index :bundlings, :bundled_sku_id
    remove_index :bundlings, :bundle_sku_id
    drop_table   :bundlings
  end
end
