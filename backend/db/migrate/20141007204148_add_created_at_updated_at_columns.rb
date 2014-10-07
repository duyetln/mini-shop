class AddCreatedAtUpdatedAtColumns < ActiveRecord::Migration
  def change
    [
      :addresses,
      :bundleds,
      :currencies,
      :pricepoint_prices
    ].each do |table|
      add_column table, :updated_at, :datetime
      add_column table, :created_at, :datetime
    end

    [
      :batches,
      :bundles,
      :coupons,
      :digital_items,
      :discounts,
      :fulfillments,
      :orders,
      :ownerships,
      :payment_methods,
      :physical_items,
      :pricepoints,
      :prices,
      :promotions,
      :purchases,
      :shipments,
      :statuses,
      :store_items,
      :transactions
    ].each do |table|
      add_column table, :updated_at, :datetime
    end
  end
end
