module ApplicationHelper
  def yesno(value)
    {
      TrueClass => 'Yes',
      FalseClass => 'No'
    }[value.class] || value
  end

  def paginate(path, prev_page, next_page, opts = {})
    prev_li_class = prev_page.blank? ? 'disabled' : ''
    next_li_class = next_page.blank? ? 'disabled' : ''

    prev_link = prev_page.blank? ? '' : "href=#{send path, { page: prev_page }.merge(opts)}"
    next_link = next_page.blank? ? '' : "href=#{send path, { page: next_page }.merge(opts)}"

    "<ul class='pager'>
      <li class='previous #{prev_li_class}'><a #{prev_link}><i class='fa fa-chevron-left'></i> Previous</a></li>
      <li class='next #{next_li_class}'><a #{next_link}>Next <i class='fa fa-chevron-right'></i></a></li>
    </ul>".html_safe
  end
end
