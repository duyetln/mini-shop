module BackendClient
  class Currency
    include APIResource
    include APIModel
    include DefaultAll
    include DefaultCreate
  end
end
