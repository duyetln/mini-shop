require 'backend_client/base'

module BackendClient
  class PhysicalItem < Base
    extend DefaultAll
    extend DefaultFind
    extend DefaultCreate
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete
  end
end
