require 'models/spec_setup'

describe Address do
  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:line1) }
  it { should have_readonly_attribute(:line2) }
  it { should have_readonly_attribute(:line3) }
  it { should have_readonly_attribute(:city) }
  it { should have_readonly_attribute(:postal_code) }
  it { should have_readonly_attribute(:country) }

  it { should belong_to(:user).inverse_of(:addresses) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:line1) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:country) }

  describe '.for_user' do
    before :each do
      model.save!
    end

    it 'returns addresses of a user' do
      expect(described_class.for_user(model.user.id)).to include(model)
    end
  end
end
