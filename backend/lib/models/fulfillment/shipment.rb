require "models/shared/item_combinable"

class Shipment < ActiveRecord::Base

  include ItemCombinable

  attr_accessible :user_id, :order_id, :shipping_address_id

  belongs_to :user
  belongs_to :order
  belongs_to :shipping_address, class_name: "Address"

  validates :user,  presence: true
  validates :order, presence: true
  validates :shipping_address, presence: true

  validates :order_id,  uniqueness: { scope: [ :item_type, :item_id ] }
  validates :item_type, inclusion: { in: %w{ PhysicalItem } }

end