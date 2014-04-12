require 'models/spec_setup'

describe User do

  it { should allow_mass_assignment_of(:first_name) }
  it { should allow_mass_assignment_of(:last_name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:birthdate) }
  it { should allow_mass_assignment_of(:password) }

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should_not allow_mass_assignment_of(:actv_code) }
  it { should have_readonly_attribute(:uuid) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:birthdate) }
  it { should validate_presence_of(:password) }

  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:password).is_at_least(5) }

  describe 'factory model' do
    it('is valid') { expect(model.valid?).to be_true }
    it('saves successfully') { expect(model.save).to be_true }
  end

  let(:password) { model.password }
  let :user do
    model.password = password
    model.save!
    model
  end

  describe '#save' do
    context 'new user' do
      it('sets uuid') { expect(model.uuid).to be_present }
      it('sets actv_code') { expect(model.actv_code).to be_present }
      it('sets password') { expect(model.password).to be_present }

      it 'encrypts password' do
        expect(BCrypt::Password.new(user.password)).to eq(password)
      end
    end

    context 'created user' do
      it('does not change uuid') { expect { model.save! }.to_not change { model.uuid } }

      context 'password changed' do
        it 'encrypts new password' do
          new_password = Faker::Lorem.characters(20)
          model.password = new_password
          expect(model.save).to be_true
          expect(BCrypt::Password.new(model.password)).to eq(new_password)
        end
      end
    end
  end

  describe '#confirmed?' do
    it 'checks blank-ness of #active_code' do
      expect(model.confirmed?).to eq(model.actv_code.blank?)
    end
  end

  describe '#confirm!' do
    before :each do
      expect(model).to receive(:confirmed?).and_return(confirmed)
    end

    context 'confirmed' do
      let(:confirmed) { true }

      it 'returns false' do
        expect(model.confirm!).to be_false
      end
    end

    context 'not confirmed' do
      let(:confirmed) { false }

      it 'returns true' do
        expect(model.confirm!).to be_true
      end

      it 'clears the activation code' do
        model.confirm!
        expect(model.actv_code).to be_blank
      end
    end
  end

  describe '.authenticate' do
    context 'non-matching uuid' do
      it('returns nil') { expect(User.authenticate(rand_str, rand_str)).to be_nil }
    end

    context 'unconfirmed user' do
      it('returns nil') { expect(User.authenticate(user.uuid, password)).to be_nil }
    end

    context 'non-matching password' do
      it('returns nil') { expect(User.authenticate(user.uuid, rand_str)).to be_nil }
    end

    context 'matching uuid, matching password, confirmed user' do
      it 'returns the user' do
        user.confirm!
        expect(User.authenticate(user.uuid, password)).to eq(user)
      end
    end
  end
end
