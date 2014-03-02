class Shipment < ActiveRecord::Base

  attr_accessible :user_id, :order_id, :item_type, :item_id, :quantity, :shipping_address_id

  belongs_to :user
  belongs_to :order
  belongs_to :item, polymorphic: true
  belongs_to :shipping_address, class_name: "Address"

  validates :user,  presence: true
  validates :order, presence: true
  validates :item,  presence: true
  validates :quantity, presence: true
  validates :shipping_address, presence: true

  validates :order_id,  uniqueness: { scope: [ :item_type, :item_id ] }
  validates :item_type, inclusion: { in: [ "PhysicalItem" ] }
  validates :quantity,  numericality: { greater_than: 0 }

end