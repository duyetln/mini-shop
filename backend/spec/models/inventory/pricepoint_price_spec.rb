require 'models/spec_setup'

describe PricepointPrice do
  it { should have_readonly_attribute(:currency_id) }
  it { should have_readonly_attribute(:pricepoint_id) }

  it { should belong_to(:pricepoint).inverse_of(:pricepoint_prices) }
  it { should belong_to(:currency) }

  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:pricepoint) }
  it { should validate_presence_of(:currency) }

  it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  it { should validate_uniqueness_of(:currency_id).scoped_to(:pricepoint_id) }

  it { should allow_mass_assignment_of(:amount) }
  it { should allow_mass_assignment_of(:pricepoint_id) }
  it { should allow_mass_assignment_of(:currency_id) }
end
