module Enum
  extend ActiveSupport::Concern

  module ClassMethods
    def enum(field, *values)
      values.flatten!
      const_name = "#{field}".upcase
      const_set(
        const_name,
        values.reduce({}) do |hash, status|
          hash[status.to_sym] = values.index(status)
          hash
        end
      )

      values.each do |status|
        define_method "#{status}?" do
          send(field.to_sym) == self.class.const_get(const_name)[status.to_sym]
        end
      end
    end
  end
end
