class CreateBatchesTable < ActiveRecord::Migration
  def up
    create_table :batches do |t|
      t.string   :name
      t.integer  :promotion_id
      t.boolean  :active
      t.datetime :created_at
    end

    add_index    :batches, :promotion_id
  end

  def down
    remove_index :batches, :promotion_id
    drop_table   :batches
  end
end
