class PhysicalItem < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate
  include DefaultActivate
  include DefaultDelete
end
