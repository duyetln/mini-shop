require 'lib/backend_client/base'

module BackendClient
  class Promotion < Base
    extend DefaultAll
    extend DefaultFind
    extend DefaultCreate
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def self.instantiate(hash = {})
      super do |promotion|
        promotion.item = Base.concretize(promotion.item)
        promotion.price = Price.instantiate(promotion.price)
      end
    end

    def batches(pagination = {})
      self.class.parse(
        self.class.resource["/#{id}/batches"].get params: pagination.slice(:page, :size, :padn)
      ).map do |hash|
        Batch.instantiate(hash)
      end
    end

    def create_batch(name, size)
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
end
