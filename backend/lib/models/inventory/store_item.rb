require 'models/shared/deletable'
require 'models/shared/displayable'
require 'models/shared/orderable'

class StoreItem < ActiveRecord::Base
  include Deletable
  include Displayable
  include Orderable
  include Itemable

  belongs_to :price

  validates :name, presence: true
  validates :price, presence: true
  validates :item_type, inclusion: { in: %w{ Bundle DigitalItem PhysicalItem } }

  delegate :amount, to: :price
  delegate :discounted?, to: :price
  delegate :fulfill!, to: :item
  delegate :reverse!, to: :item
  delegate :title, to: :item, allow_nil: true
  delegate :description, to: :item, allow_nil: true
  delegate :available?, to: :item
  delegate :active?, to: :item
end
