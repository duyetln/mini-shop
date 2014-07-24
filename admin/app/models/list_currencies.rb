class ListCurrencies < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::Currency.all(pagination)
    }.merge(pagination)
  end
end
