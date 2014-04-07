class CreateStatusesTable < ActiveRecord::Migration
  def up
    create_table :statuses do |t|
      t.integer  :owner_id
      t.string   :owner_type
      t.integer  :status
      t.datetime :created_at
    end

    add_index    :statuses, [:owner_id, :owner_type]
  end

  def down
    remove_index :statuses, [:owner_id, :owner_type]
    drop_table   :statuses
  end
end
