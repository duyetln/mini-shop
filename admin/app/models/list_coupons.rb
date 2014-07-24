class ListCoupons < Mutations::Command
  include Pagination

  required do
    integer :batch_id
  end

  def execute
    {
      list: BackendClient::Batch.find(batch_id).coupons(pagination)
    }.merge(pagination)
  end
end
