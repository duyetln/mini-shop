require 'lib/base'

module BackendClient
  class PhysicalItem < Base
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete
  end
end
