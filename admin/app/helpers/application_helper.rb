module ApplicationHelper
  def yesno(value)
    {
      TrueClass => 'Yes',
      FalseClass => 'No'
    }[value.class] || value
  end
end
