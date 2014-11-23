module ApplicationHelper
  def yesno(value)
    {
      TrueClass => 'Yes',
      FalseClass => 'No'
    }[value.class] || value
  end

  def print_address(address)
    [address.line1, address.line2, address.line3, address.city, address.region, address.postal_code, address.country].select(&:present?).compact.join(', ')
  end
end
