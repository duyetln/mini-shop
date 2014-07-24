class ListDigitalItems < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::DigitalItem.all(pagination)
    }.merge(pagination)
  end
end
