require 'spec_helper'

describe Address do

  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:line1) }
  it { should have_readonly_attribute(:line2) }
  it { should have_readonly_attribute(:line3) }
  it { should have_readonly_attribute(:city) }
  it { should have_readonly_attribute(:postal_code) }
  it { should have_readonly_attribute(:country) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:line1) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:country) }

end
