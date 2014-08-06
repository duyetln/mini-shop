class Discount < ActiveRecord::Base
  validates :rate, presence: true
  validates :name, presence: true

  validates :rate, numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: true

  validate :discount_dates

  attr_accessible :name, :rate, :start_at, :end_at

  def rate_at(dt = DateTime.now)
    active_at?(dt) ? rate : BigDecimal.new('0.0')
  end

  def active_at?(dt = DateTime.now)
    start_set = start_at.present?
    end_set   = end_at.present?

    ( start_set &&  end_set && start_at <= dt && dt <= end_at) ||
    ( start_set && !end_set && start_at <= dt) ||
    (!start_set &&  end_set && dt <= end_at) ||
    (!start_set && !end_set)
  end

  def discounted?(dt = DateTime.now)
    rate_at(dt) > 0.0
  end

  def current_rate
    rate_at(DateTime.now)
  end

  def current_active?
    active_at?(DateTime.now)
  end

  protected

  def discount_dates
    unless  start_at.present? && end_at.present? ? start_at <= end_at : true
      errors.add(:start_at, 'must be before or same as end_at')
      errors.add(:end_at, 'must be after or same as start_at')
    end
  end
end
