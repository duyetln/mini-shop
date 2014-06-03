require 'models/shared/deletable'
require 'models/shared/activable'

class Batch < ActiveRecord::Base
  include Deletable
  include Activable

  belongs_to :promotion
  has_many :coupons

  validates :name, presence: true
  validates :promotion, presence: true

  def deletable?
    inactive? && super
  end
end
