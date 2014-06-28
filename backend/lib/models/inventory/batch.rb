require 'models/shared/deletable'
require 'models/shared/activable'

class Batch < ActiveRecord::Base
  include Deletable
  include Activable

  attr_readonly :promotion_id

  belongs_to :promotion
  has_many :coupons

  validates :name, presence: true
  validates :promotion, presence: true

  def deletable?
    inactive? && super
  end

  def create_coupons(qty = 0)
    qty.times do
      until coupons.create
      end
    end
  end
end
