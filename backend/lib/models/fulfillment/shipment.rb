class Shipment < ActiveRecord::Base

  attr_accessible :user_id, :item_type, :item_id, :shipping_address_id

  belongs_to :user
  belongs_to :item, polymorphic: true
  belongs_to :shipping_address, class_name: Address

  validates :user_id,   presence: true
  validates :item_type, presence: true
  validates :item_id,   presence: true
  validates :shipping_address_id, presence: true

  validates :user, presence: true
  validates :item, presence: true
  validates :shipping_address, presence: true

end