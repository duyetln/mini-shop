module ResourcesHelper
  def update_resource(scope, *keys)
    resource = self.resource
    resource.merge!(params.require(scope).permit(*keys))
    resource.update!(*keys)
    resource
  end

  def resource_class
    @resource_class
  end

  def resource
    resource_class.find(id)
  end
end