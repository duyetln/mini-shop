class ListPrices < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::Price.all(pagination)
    }.merge(pagination)
  end
end
