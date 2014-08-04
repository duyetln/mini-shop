module ApplicationHelper
  def yesno(value)
    {
      TrueClass => 'Yes',
      FalseClass => 'No'
    }[value.class] || value
  end

  def paginate(path, prev_page, next_page)
    ul_class = 'pagination pull-right'
    prev_li_class = prev_page.blank? ? 'disabled' : ''
    next_li_class = next_page.blank? ? 'disabled' : ''

    prev_link = prev_page.blank? ? '' : "href=#{send path, page: prev_page}"
    next_link = next_page.blank? ? '' : "href=#{send path, page: next_page}"

    "<ul class='pagination pull-right'>
      <li class='#{prev_li_class}'><a #{prev_link}><<</a></li>
      <li class='#{next_li_class}'><a #{next_link}>>></a></li>
    </ul>".html_safe
  end
end
