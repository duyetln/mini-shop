class Promotion < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate
  include DefaultActivate
  include DefaultDelete

  def self.instantiate(hash = {})
    super do |promotion|
      promotion.item = ServiceResource.concretize(promotion.item)
      promotion.price = Price.instantiate(promotion.price)
    end
  end

  def batches
    self.class.parse(
      self.class.resource["/#{id}/batches"].get
    ).map do |hash|
      Batch.instantiate(hash)
    end
  end

  def create_batch(name, qty)
    self.class.parse(
      self.class.resource["/#{id}/batches"].post Batch.params(name: name, size: size)
    ) do |hash|
      load!(hash)
    end
  end

  def create_batches(qty, batch_size)
    self.class.parse(
      self.class.resource["/#{id}/batches/generate"].post({ qty: qty }.merge(Batch.params(size: batch_size)))
    ) do |hash|
      load!(hash)
    end
  end
end
