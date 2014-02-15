class Currency < ActiveRecord::Base
  
  validates :code, length: { is: 3 }
  validates :code, presence: true
  validates :code, uniqueness: true

  before_save :upcase_code

  def self.exchange(amount, src_unit, dst_unit)

    amount   = BigDecimal.new(amount.to_s)
    src_unit = src_unit.upcase.to_sym
    dst_unit = dst_unit.upcase.to_sym

    src_rate = CURRENCY_RATES[:USD][src_unit]
    dst_rate = CURRENCY_RATES[:USD][dst_unit]

    ( amount * dst_rate / src_rate ).ceil(4)
  end

  protected

  def upcase_code
    code.upcase!
  end
end