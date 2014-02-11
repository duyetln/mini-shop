class CreateDigitalItemsTable < ActiveRecord::Migration
  def up
    create_table :digital_items do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.timestamps
    end
  end

  def down
    drop_table    :digital_items
  end
end
