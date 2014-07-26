module ParamsHelper
  def scoped_params(scope, *keys)
    scope = params.require(scope)
    scope = scope.permit(*keys) if keys.present?
    scope
  end

  def id
    scoped_params(:id)
  end
end
