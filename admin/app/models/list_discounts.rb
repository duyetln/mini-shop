class ListDiscounts < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::Discount.all(pagination)
    }.merge(pagination)
  end
end
