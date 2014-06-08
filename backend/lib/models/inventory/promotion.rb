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

  has_many :batches

  validates :name, presence: true
  validates :item_type, inclusion: { in: %w{ Bundle DigitalItem PhysicalItem } }
  delegate :fulfill!, to: :item
  delegate :reverse!, to: :item
  delegate :available?, to: :item

  def activable?
    item.active? && super
  end

  def deletable?
    item.deleted? && super
  end

  def create_batches(qty, batch_size, batch_name = nil)
    batches = []
    batch_num = qty / batch_size
    remainder = qty % batch_size
    batch_num.times do |index|
      batches << create_batch(
        batch_size,
        batch_name.present? && batch_name || "Auto generated batch #{index + 1}"
      )
    end
    if remainder > 0
      batches << create_batch(
        remainder,
        batch_name.present? && batch_name || "Auto generated batch #{batch_num + 1}"
      )
    end
    batches
  end

  def create_batch(batch_size, batch_name = nil)
    batch = batches.create(name: batch_name)
    batch_size.times do
      until batch.coupons.create
      end
    end
    batch
  end
end
