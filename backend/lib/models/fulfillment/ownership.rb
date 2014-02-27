class Ownership < ActiveRecord::Base

  attr_accessible :user_id, :order_id, :item_type, :item_id

  ITEM_TYPES = [ "DigitalItem" ]

  belongs_to :user
  belongs_to :order
  belongs_to :item, polymorphic: true

  validates :user_id,   presence: true
  validates :order_id,  presence: true
  validates :order_id,  uniqueness: { scope: [ :item_type, :item_id ] }
  validates :item_type, presence: true
  validates :item_type, inclusion: { in: ITEM_TYPES }
  validates :item_id,   presence: true
  validates :quantity,  presence: true
  validates :quantity,  numericality: { greater_than: 0 }

  validates :user,  presence: true
  validates :order, presence: true
  validates :item,  presence: true

end