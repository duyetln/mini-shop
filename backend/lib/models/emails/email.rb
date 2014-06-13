class Email < SimpleDelegator
  def initialize(payload={})
    __setobj__(generate_email(payload))
  end

  def generate_email(payload={})
    fail 'Must be implemented in derived class'
  end
end
