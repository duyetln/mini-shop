require 'models/shared/itemable'
require 'models/shared/quantifiable'

module ItemCombinable
  extend ActiveSupport::Concern
  include Itemable
  include Quantifiable

  module ClassMethods
    def add_or_update(item, options = {})
      qty   =  options[:qty]      || 1
      acc   = !options.key?(:acc) || !!options[:acc]
      conds =  options[:conds]    || {}
      attrs =  options[:attrs]    || {}

      record = where({
        item_type: item.class,
        item_id: item.id
      }.merge(conds)).first_or_initialize(attrs)

      record.qty ||= 0
      acc ? record.qty += qty : record.qty = qty

      yield record if block_given?
      record.save! && record
    end

    def retrieve(item)
      record = find { |r| r.item == item } || find { |r| r == item } || find_by_id(item)
      record.present? && (!block_given? || (yield record)) && record
    end
  end
end
