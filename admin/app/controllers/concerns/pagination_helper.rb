module PaginationHelper
  def pagination
    @page = params[:page].to_i
    @size = params[:size].to_i
    @padn = params[:padn].to_i
    @sort = params[:sort].to_s

    @page = @page >= 1 && @page || 1
    @size = @size >= 1 && @size || nil
    @padn = @padn >= 1 && @padn || nil
    @sort = ([ 'asc', 'desc' ].include?(@sort) && @sort || 'desc').downcase

    @next_page = @page + 1
    @prev_page = @page > 1 && (@page - 1) || nil

    {
      page: @page,
      size: @size,
      padn: @padn,
      sort: @sort,
      next_page: @next_page,
      prev_page: @prev_page
    }
  end
end
