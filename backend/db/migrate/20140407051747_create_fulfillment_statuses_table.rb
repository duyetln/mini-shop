class CreateFulfillmentStatusesTable < ActiveRecord::Migration
  def up
    create_table :fulfillment_statuses do |t|
      t.integer  :fulfillable_id
      t.string   :fulfillable_type
      t.integer  :status
      t.datetime :created_at
    end

    add_index    :fulfillment_statuses, [:fulfillable_id, :fulfillable_type], name: "fulfillment_statues_fulfillable_type_id"
  end

  def down
    remove_index :fulfillment_statuses, name: "fulfillment_statues_fulfillable_type_id"
    drop_table   :fulfillment_statuses  
  end
end
