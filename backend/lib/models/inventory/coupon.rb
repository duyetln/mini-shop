require 'models/shared/displayable'
require 'models/shared/orderable'

class Coupon < ActiveRecord::Base
  include Displayable
  include Orderable

  attr_readonly :code, :batch_id

  belongs_to :batch, inverse_of: :coupons
  belongs_to :user, class_name: 'User', foreign_key: :used_by, inverse_of: :coupons

  validates :batch, presence: true
  validates :code, uniqueness: true
  delegate :promotion,   to: :batch,     allow_nil: true
  delegate :item,        to: :promotion, allow_nil: true
  delegate :title,       to: :promotion, allow_nil: true
  delegate :description, to: :promotion, allow_nil: true
  delegate :amount,      to: :promotion, allow_nil: true
  delegate :available?,  to: :promotion, allow_nil: true

  scope :used, -> { where(used: true) }
  scope :unused, -> { where(used: false) }

  after_initialize :set_values

  def active?
    batch.try(:active?) && promotion.try(:active?)
  end

  def inactive?
    !active?
  end

  def deleted?
    batch.blank? || batch.deleted? || promotion.blank? || promotion.deleted?
  end

  def kept?
    !deleted?
  end

  def fulfill!(order, qty)
    unless used?
      used_by!(order.user)
      promotion.fulfill!(order, qty)
    end
  end

  def reverse!(order)
    if used?
      promotion.reverse!(order)
    end
  end

  def used_by!(user)
    unless used?
      self.used = true
      self.used_by = user.id
      self.used_at = DateTime.now
      save!
    end
  end

  protected

  def set_values
    if new_record?
      self.code = SecureRandom.hex(8).upcase
      self.used = false
      self.used_by = nil
      self.used_at = nil
    end
  end
end
