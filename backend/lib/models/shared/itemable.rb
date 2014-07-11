=begin
dependencies: must have 'item_type', 'item_id' columns
interface methods:
  item_type
  item_type=
  item_id
  item_id=
  item
  item=
=end

module Itemable
  extend ActiveSupport::Concern

  included do
    attr_readonly :item_type, :item_id

    belongs_to :item, polymorphic: true

    validates :item, presence: true
  end
end
