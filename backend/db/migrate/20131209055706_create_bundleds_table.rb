class CreateBundledsTable < ActiveRecord::Migration
  def up
    create_table :bundleds do |t|
      t.integer  :bundle_id
      t.integer  :item_id
      t.string   :item_type
      t.integer  :qty
      t.timestamps
    end

    add_index    :bundleds, :bundle_id
    add_index    :bundleds, :item_id
    add_index    :bundleds, :item_type
  end

  def down
    remove_index :bundleds, :item_type
    remove_index :bundleds, :item_id
    remove_index :bundleds, :bundle_id
    drop_table   :bundleds
  end
end
