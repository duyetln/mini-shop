class Discount < ActiveRecord::Base

  validates :rate, numericality: { greater_than_or_equal_to: 0 }
  validates :rate, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  def current_rate
    self.rate_at(DateTime.now)
  end

  def rate_at(datetime)
    zero_rate = BigDecimal.new("0.0")
    start_set = start_at.present?
    end_set   = end_at.present?
    
    case
    when  start_set &&  end_set
      self.start_at <= datetime && datetime <= self.end_at ? self.rate : zero_rate
    when  start_set && !end_set
      self.start_at <= datetime ? self.rate : zero_rate
    when !start_set &&  end_set then
      datetime <= self.end_at ? self.rate : zero_rate
    when !start_set && !end_set
      self.rate
    end
  end

  def discounted?
    current_rate > 0.0
  end

end