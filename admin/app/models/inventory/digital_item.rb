class DigitalItem < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate
  include DefaultActivate
  include DefaultDelete
end
