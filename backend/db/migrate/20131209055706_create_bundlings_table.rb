class CreateBundlingsTable < ActiveRecord::Migration
  def up
    create_table :bundlings do |t|
      t.integer  :bundle_id
      t.integer  :item_id
      t.string   :item_type
      t.integer  :qty
      t.timestamps
    end

    add_index    :bundlings, :bundle_id
    add_index    :bundlings, :item_id
    add_index    :bundlings, :item_type
  end

  def down
    remove_index :bundlings, :item_type
    remove_index :bundlings, :item_id
    remove_index :bundlings, :bundle_id
    drop_table   :bundlings
  end
end
