class ListPricepoints < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::Pricepoint.all(pagination)
    }.merge(pagination)
  end
end
