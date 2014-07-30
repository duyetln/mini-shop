module BackendClient
  class Promotion
    include APIResource
    include APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def self.build_attributes(hash = {})
      super do |promotion|
        promotion.item = APIModel.instantiate(promotion.item)
        promotion.price = Price.new(promotion.price)
      end
    end

    def batches(pagination = {})
      self.class.get(
        path: "/#{id}/batches",
        payload: pagination.slice(:page, :size, :padn)
      ).map do |hash|
        Batch.new(hash)
      end
    end

    def create_batch(name, size)
      load!(
        self.class.post(
          path: "/#{id}/batches",
          payload: Batch.params(name: name, size: size)
        )
      )
    end

    def create_batches(qty, batch_size)
      load!(
        self.class.post(
          path: "/#{id}/batches/generate",
          payload: { qty: qty }.merge(Batch.params(size: batch_size))
        )
      )
    end
  end
end
