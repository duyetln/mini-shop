require 'models/shared/deletable'
require 'models/shared/displayable'
require 'models/shared/orderable'
require 'models/shared/priceable'

class StoreItem < ActiveRecord::Base
  include Deletable
  include Displayable
  include Orderable
  include Itemable
  include Priceable

  validates :name, presence: true
  validates :item_type, inclusion: { in: %w(Bundle DigitalItem PhysicalItem) }

  delegate :fulfill!, to: :item
  delegate :reverse!, to: :item
  delegate :title, to: :item, allow_nil: true
  delegate :description, to: :item, allow_nil: true
  delegate :available?, to: :item
  delegate :active?, to: :item
end
