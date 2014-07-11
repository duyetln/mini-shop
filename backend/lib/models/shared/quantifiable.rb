=begin
dependencies: must have 'qty' column
interface methods:
  qty
  qty=
=end

module Quantifiable
  extend ActiveSupport::Concern

  included do
    validates :qty, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 }
  end
end
