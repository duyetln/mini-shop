class ListStoreItems < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::StoreItem.all(pagination)
    }.merge(pagination)
  end
end
