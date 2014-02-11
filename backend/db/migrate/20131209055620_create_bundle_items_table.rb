class CreateBundleItemsTable < ActiveRecord::Migration
  def up
    create_table :bundle_items do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.timestamps
    end
  end

  def down
    drop_table    :bundle_items
  end
end
