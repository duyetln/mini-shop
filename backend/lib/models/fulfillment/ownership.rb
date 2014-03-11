require "models/shared/item_combinable"

class Ownership < ActiveRecord::Base

  include ItemCombinable

  attr_readonly :user_id, :order_id

  belongs_to :user
  belongs_to :order

  validates :user,  presence: true
  validates :order, presence: true

  validates :order_id,  uniqueness: { scope: [ :item_type, :item_id ] }
  validates :item_type, inclusion: { in: %w{ DigitalItem } }
end