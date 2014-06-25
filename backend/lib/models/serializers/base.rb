class ServiceResourceSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :resource_type, :resource_id

  def resource_type
    object.class.name.demodulize
  end

  def resource_id
    object.id
  end
end

class StatusSerializer < ServiceResourceSerializer
  attributes :source_type, :source_id, :status, :created_at
end

class DynamicSerializer < SimpleDelegator
  def initialize(resource, options = {})
    __setobj__("#{resource.class.name.demodulize}Serializer".constantize.new(resource, options))
  end
end
