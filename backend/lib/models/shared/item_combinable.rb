require "models/shared/itemable"
require "models/shared/quantifiable"

module ItemCombinable

  extend ActiveSupport::Concern
  include Itemable
  include Quantifiable

  module ClassMethods

    def add_or_update(item, qty=1, acc=true, conds={})
      record = where({
        item_type: item.class, 
        item_id: item.id
      }.merge(conds)).first_or_initialize

      record.quantity ||= 0
      acc ? 
        record.quantity += qty.to_i : 
        record.quantity  = qty.to_i

      yield record if block_given?
      record.save! ? record : nil
    end

    def get(item)
      record = detect{ |r| r.item == item } || detect{ |r| r == item }
      yield record if block_given?
      record
    end

  end

end