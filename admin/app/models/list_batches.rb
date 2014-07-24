class ListBatches < Mutations::Command
  include Pagination

  required do
    integer :promotion_id
  end

  def execute
    {
      list: BackendClient::Promotion.find(promotion_id).batches(pagination)
    }.merge(pagination)
  end
end
