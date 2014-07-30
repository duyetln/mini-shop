module BackendClient
  class PhysicalItem
    include APIResource
    include APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete
  end
end
