class ListBundles < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::Bundle.all(pagination)
    }.merge(pagination)
  end
end
