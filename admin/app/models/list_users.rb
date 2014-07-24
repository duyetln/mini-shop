class ListUsers < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::User.all(pagination)
    }.merge(pagination)
  end
end
