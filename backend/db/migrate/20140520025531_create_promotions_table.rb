class CreatePromotionsTable < ActiveRecord::Migration
  def up
    create_table :promotions do |t|
      t.string   :name
      t.string   :title
      t.string   :description
      t.boolean  :active
      t.integer  :price_id
      t.datetime :created_at
    end
  end

  def down
    drop_table   :promotions
  end
end
