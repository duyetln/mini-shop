class CreatePhysicalSkusTable < ActiveRecord::Migration
  def up
    create_table :physical_skus do |t|
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.integer  :quantity
      t.timestamps
    end
  end

  def down
    drop_table    :physical_skus
  end
end
