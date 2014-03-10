require "spec_helper"

describe Address do

  [:user_id, :line1, :line2, :line3, :city, :region, :postal_code, :country].each do |attr|

    it { should allow_mass_assignment_of(attr) }
    it { should have_readonly_attribute(attr) }
  end

  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:line1) } 
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:country) }

end