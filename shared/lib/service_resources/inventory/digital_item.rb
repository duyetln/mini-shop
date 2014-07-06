class DigitalItem < ServiceResource
  extend DefaultAll
  extend DefaultFind
  extend DefaultCreate
  include DefaultUpdate
  include DefaultActivate
  include DefaultDelete
end
