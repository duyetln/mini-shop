require 'models/shared/item_combinable'
require 'models/shared/deletable'

class Ownership < ActiveRecord::Base
  include ItemCombinable
  include Deletable

  attr_readonly :user_id, :order_id

  belongs_to :user, inverse_of: :ownerships
  belongs_to :order

  validates :user,  presence: true
  validates :order, presence: true

  validates :order_id, uniqueness: { scope: [:item_type, :item_id, :deleted] }, unless: :deleted?
  validates :item_type, inclusion: { in: %w(DigitalItem) }

  scope :for_user, -> user_id { joins(:user).where(users: { id: user_id }).readonly(true) }
end
