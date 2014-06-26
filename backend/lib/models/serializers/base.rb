class ServiceResourceSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :resource_type, :resource_id, :created_at, :updated_at

  def resource_type
    object.class.name.demodulize
  end

  def resource_id
    object.id
  end

  def created_at
    object && object.respond_to?(:created_at) ? object.created_at : nil
  end

  def updated_at
    object && object.respond_to?(:updated_at) ? object.updated_at : nil
  end
end

class StatusSerializer < ServiceResourceSerializer
  attributes :source_type, :source_id, :status
end

class DynamicSerializer < SimpleDelegator
  def initialize(resource, options = {})
    __setobj__("#{resource.class.name.demodulize}Serializer".constantize.new(resource, options))
  end
end
