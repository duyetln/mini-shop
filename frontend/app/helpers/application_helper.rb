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

  def first_name_placeholder; 'First Name'; end
  def last_name_placeholder; 'Last Name'; end
  def email_placeholder; 'Email'; end
  def birthdate_placeholder; 'Birthdate (mm/dd/yyyy)'; end
  def password_placeholder; 'Password'; end
  def password_confirmation_placeholder; 'Password Confirmation'; end
end
