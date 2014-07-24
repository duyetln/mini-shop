class ListPhysicalItems < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::PhysicalItem.all(pagination)
    }.merge(pagination)
  end
end
