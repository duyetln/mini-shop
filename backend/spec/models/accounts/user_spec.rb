require 'models/spec_setup'

describe User do
  context 'class' do
    let(:subject) { described_class }

    it { should respond_to(:confirmed) }
    it { should respond_to(:unconfirmed) }
  end

  it { should have_many(:purchases) }
  it { should have_many(:addresses) }
  it { should have_many(:payment_methods) }
  it { should have_many(:transactions) }
  it { should have_many(:ownerships) }
  it { should have_many(:shipments) }
  it { should have_many(:coupons) }

  it { should allow_mass_assignment_of(:first_name) }
  it { should allow_mass_assignment_of(:last_name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:birthdate) }
  it { should allow_mass_assignment_of(:password) }

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should_not allow_mass_assignment_of(:actv_code) }
  it { should_not allow_mass_assignment_of(:confirmed) }
  it { should have_readonly_attribute(:uuid) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:birthdate) }
  it { should validate_presence_of(:password) }

  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:uuid) }
  it { should ensure_length_of(:password).is_at_least(5) }

  let(:password) { model.password }
  let(:actv_code) { model.actv_code }
  let :user do
    model.password = password
    model.save!
    model
  end

  describe '#save' do
    context 'new user' do
      it('sets uuid') { expect(model.uuid).to be_present }
      it('sets actv_code') { expect(model.actv_code).to be_present }
      it('is unconfirmed') { expect(model).to_not be_confirmed }
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
    context 'confirmed' do
      before :each do
        model.confirmed = true
      end

      it 'does not return true' do
        expect(model.confirm!).to_not be_true
      end
    end

    context 'not confirmed' do
      before :each do
        model.confirmed = false
      end

      it 'returns true' do
        expect(model.confirm!).to be_true
      end

      it 'clears the activation code' do
        expect { model.confirm! }.to change { model.actv_code }.to(nil)
      end

      it 'sets confirmed flag to true' do
        expect { model.confirm! }.to change { model.confirmed? }.to(true)
      end
    end
  end

  describe '.authenticate!' do
    context 'unconfirmed user' do
      before :each do
        expect(user).to_not be_confirmed
      end

      it 'raise an error' do
        expect(user).to_not be_confirmed
        expect { User.authenticate!(user.email, password) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'confirmed user' do
      before :each do
        expect { user.confirm! }.to change { user.confirmed? }.to(true)
      end

      context 'wrong email' do
        it 'raises an error' do
          expect { User.authenticate!(rand_str, password) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'wrong password' do
        it 'returns false' do
          expect(User.authenticate!(user.email, rand_str)).to be_false
        end
      end

      context 'matching email, matching password' do
        it 'returns the user' do
          expect(User.authenticate!(user.email, password)).to eq(user)
        end
      end
    end
  end

  describe '.confirm!' do
    context 'confirmed user' do
      before :each do
        expect { user.confirm! }.to change { user.confirmed? }.to(true)
      end

      it 'raises an error' do
        expect { User.confirm!(user.uuid, actv_code) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'unconfirmed user' do
      before :each do
        expect(user).to_not be_confirmed
      end

      context 'wrong uuid' do
        it 'raises an error' do
          expect { User.confirm!(rand_str, actv_code) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'wrong activation code' do
        it 'raises an error' do
          expect { User.confirm!(user.uuid, rand_str) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'matching uuid, matching activation code' do
        it 'confirms the user' do
          expect(User.confirm!(user.uuid, actv_code)).to eq(user)
          expect(user.reload).to be_confirmed
        end
      end
    end
  end
end
