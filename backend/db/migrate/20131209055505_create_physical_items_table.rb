class CreatePhysicalItemsTable < ActiveRecord::Migration
  def up
    create_table :physical_items do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.integer  :qty
      t.timestamps
    end
  end

  def down
    drop_table    :physical_items
  end
end
