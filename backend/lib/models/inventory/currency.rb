class Currency < ActiveRecord::Base
  attr_readonly :code

  validates :code, length: { is: 3 }
  validates :code, presence: true
  validates :code, uniqueness: true

  before_save :upcase_code

  def self.exchange(amount, src_curr, dst_curr)
    amount   = BigDecimal.new(amount.to_s)
    src_unit = src_curr.code.upcase.to_sym
    dst_unit = dst_curr.code.upcase.to_sym

    src_rate = Application.config.currency_rates[:USD][src_unit]
    dst_rate = Application.config.currency_rates[:USD][dst_unit]

    (amount * dst_rate / src_rate).ceil(4)
  end

  protected

  def upcase_code
    code.upcase!
  end
end
