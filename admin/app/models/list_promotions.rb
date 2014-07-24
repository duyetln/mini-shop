class ListPromotions < Mutations::Command
  include Pagination

  def execute
    {
      list: BackendClient::Promotion.all(pagination)
    }.merge(pagination)
  end
end
