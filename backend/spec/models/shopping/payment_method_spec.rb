require "spec_helper"

describe PaymentMethod do

  it { should allow_mass_assignment_of(:user_id) } 
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:currency_id) }
  it { should allow_mass_assignment_of(:balance) }

  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:name) }
  it { should have_readonly_attribute(:currency_id) }

  it { should belong_to(:user) }
  it { should belong_to(:currency) }
  it { should have_many(:payments) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:balance) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:user) }

  it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }

end