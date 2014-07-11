require 'models/shared/deletable'
require 'models/shared/displayable'
require 'models/shared/activable'
require 'models/shared/itemable'
require 'models/shared/priceable'
require 'models/shared/orderable'

class Promotion < ActiveRecord::Base
  include Deletable
  include Displayable
  include Activable
  include Itemable
  include Priceable
  include Orderable

  has_many :batches, inverse_of: :promotion

  validates :name, presence: true
  validates :item_type, inclusion: { in: %w{ Bundle DigitalItem PhysicalItem } }
  delegate :fulfill!, to: :item
  delegate :reverse!, to: :item
  delegate :available?, to: :item

  def activable?
    item.active? && super
  end

  def deletable?
    inactive? && super
  end

  def create_batches(qty, batch_size = 0)
    batches = []
    qty.times do |index|
      batches << create_batch(
        "Auto generated batch #{index + 1}",
        batch_size
      )
    end
    batches
  end

  def create_batch(batch_name, batch_size = 0)
    batch = batches.create(name: batch_name)
    batch.create_coupons(batch_size)
    batch
  end
end
