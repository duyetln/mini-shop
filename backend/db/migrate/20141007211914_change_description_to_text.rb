class ChangeDescriptionToText < ActiveRecord::Migration
  def up
    [:bundles, :digital_items, :physical_items, :promotions].each do |table|
      change_column table, :description, :text
    end
  end

  def down
    [:bundles, :digital_items, :physical_items, :promotions].each do |table|
      change_column table, :description, :string
    end
  end
end
