class CreatePromotionsTable < ActiveRecord::Migration
  def up
    create_table :promotions do |t|
      t.string   :name
      t.string   :title
      t.string   :description
      t.string   :item_type
      t.integer  :item_id
      t.boolean  :active
      t.boolean  :deleted
      t.integer  :price_id
      t.datetime :created_at
    end

    add_index    :promotions, [:item_type, :item_id]
  end

  def down
    remove_index :promotions, [:item_type, :item_id]
    drop_table   :promotions
  end
end
