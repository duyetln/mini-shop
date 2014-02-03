class Currency < ActiveRecord::Base
  
  validates :code, length: { is: 3 }
  validates :code, presence: true
  validates :code, uniqueness: true

  before_save :upcase_code

  def upcase_code
    self.code.upcase!
  end
end