require 'models/spec_setup'

shared_examples 'email' do
  it { should respond_to(:generate_email) }
  it { should respond_to(:from) }
  it { should respond_to(:to) }
  it { should respond_to(:subject) }
  it { should respond_to(:body) }

  it 'sets receiver email' do
    expect(model.to).to include(receiver_email)
  end

  it 'sets sender email' do
    expect(model.from).to be_present
  end

  it 'sets email subject' do
    expect(model.subject).to be_present
  end

  it 'sets email body' do
    expect(model.body).to be_present
  end
end

describe PurchaseReceiptEmail do
  let(:purchase) { FactoryGirl.create :purchase, :orders }
  let(:model) { described_class.new(purchase_id: purchase.id) }
  let(:receiver_email) { purchase.user.email }

  context 'committed purchase' do
    before :each do
      expect { purchase.commit! }.to change { purchase.committed? }.to(true)
    end

    include_examples 'email'
  end

  context 'pending purchase' do
    before :each do
      expect(purchase).to be_pending
    end

    it 'raises an error' do
      expect { model }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

describe AccountActivationEmail do
  let(:user) { FactoryGirl.create :user }
  let(:model) { described_class.new(user_id: user.id) }
  let(:receiver_email) { user.email }

  context 'unconfirmed user' do
    before :each do
      expect(user).to_not be_confirmed
    end

    include_examples 'email'
  end

  context 'confirmed user' do
    before :each do
      expect { user.confirm! }.to change { user.confirmed? }.to(true)
    end

    it 'raises an error' do
      expect { model }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

describe PurchaseStatusEmail do
  let!(:purchase) { FactoryGirl.create :purchase, :orders }
  let(:model) { described_class.new(purchase_id: purchase.id) }
  let(:receiver_email) { purchase.user.email }

  context 'fulfilled purchase' do
    before :each do
      activate_inventory!
      expect do
        purchase.commit!
        purchase.pay!
        purchase.fulfill!
      end.to change { purchase.orders.all?(&:unmarked?) }.to(false)
    end

    include_examples 'email'
  end

  context 'pending purchase' do
    before :each do
      expect(purchase).to be_pending
    end

    it 'raises an error' do
      expect { model }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
