class Discount < ActiveRecord::Base

  validates :rate, numericality: { greater_than_or_equal_to: 0 }
  validates :rate, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  def current_rate
    rate_at(DateTime.now)
  end

  def rate_at(datetime)
    zero_rate = BigDecimal.new("0.0")
    start_set = start_at.present?
    end_set   = end_at.present?
    
    case
    when  start_set &&  end_set
      start_at <= datetime && datetime <= end_at ? rate : zero_rate
    when  start_set && !end_set
      start_at <= datetime ? rate : zero_rate
    when !start_set &&  end_set then
      datetime <= end_at ? rate : zero_rate
    when !start_set && !end_set
      rate
    end
  end

  def discounted?
    current_rate > 0.0
  end

end