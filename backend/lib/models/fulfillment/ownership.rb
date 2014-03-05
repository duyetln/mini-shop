class Ownership < ActiveRecord::Base

  attr_accessible :user_id, :order_id, :item_type, :item_id

  belongs_to :user
  belongs_to :order
  belongs_to :item, polymorphic: true

  validates :user,  presence: true
  validates :order, presence: true
  validates :item,  presence: true
  validates :quantity, presence: true

  validates :order_id,  uniqueness: { scope: [ :item_type, :item_id ] }
  validates :item_type, inclusion: { in: %w{ DigitalItem } }
  validates :quantity,  numericality: { greater_than: 0 }
end