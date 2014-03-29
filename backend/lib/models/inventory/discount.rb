class Discount < ActiveRecord::Base

  validates :rate, presence: true
  validates :name, presence: true

  validates :rate, numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: true

  validate :discount_dates

  def rate_at(dt=DateTime.now)
    zero_rate = BigDecimal.new('0.0')
    start_set = start_at.present?
    end_set   = end_at.present?
    
    case
    when  start_set &&  end_set
      start_at <= dt && dt <= end_at ? rate : zero_rate
    when  start_set && !end_set
      start_at <= dt ? rate : zero_rate
    when !start_set &&  end_set then
      dt <= end_at ? rate : zero_rate
    when !start_set && !end_set
      rate
    end
  end

  def discounted?(dt=DateTime.now)
    rate_at(dt) > 0.0
  end

  alias_method :current_rate, :rate_at

  protected

  def discount_dates
    unless ( start_at.present? && end_at.present? ? start_at <= end_at : true )
      errors.add(:start_at, 'must be before or same as end_at')
      errors.add(:end_at, 'must be after or same as start_at')
    end
  end

end