class CreatePricepointsTable < ActiveRecord::Migration
  def up
    create_table :pricepoints do |t|
      t.string   :name
      t.datetime :created_at
    end

    add_index    :pricepoints, :name
  end

  def down
    remove_index :pricepoints, :name
    drop_table   :pricepoints
  end
end
