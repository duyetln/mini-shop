class CreateBundlingsTable < ActiveRecord::Migration
  def up
    create_table :bundlings do |t|
      t.integer  :bundle_item_id
      t.integer  :bundled_item_id
      t.string   :bundled_item_type
      t.timestamps
    end

    add_index    :bundlings, :bundle_item_id
    add_index    :bundlings, :bundled_item_id
    add_index    :bundlings, :bundled_item_type
  end

  def down
    remove_index :bundlings, :bundled_item_type
    remove_index :bundlings, :bundled_item_id
    remove_index :bundlings, :bundle_item_id
    drop_table   :bundlings
  end
end
