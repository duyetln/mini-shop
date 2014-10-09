shared_examples 'transaction' do
  include_examples 'api model'

  describe '.initialize' do
    it 'sets payment method correctly' do
      expect(
        full_model.payment_method
      ).to be_instance_of(BackendClient::PaymentMethod)
    end

    it 'sets amount correctly' do
      expect(
        full_model.amount
      ).to be_instance_of(BigDecimal)
    end

    it 'sets committed_at correctly' do
      expect(
        full_model.committed_at
      ).to be_instance_of(DateTime)
    end

    it 'sets currency correctly' do
      expect(
        full_model.currency
      ).to be_instance_of(BackendClient::Currency)
    end
  end

  describe '#user' do
    let(:user) { BackendClient::User.instantiate parse(user_payload) }

    before :each do
      bare_model.user_id = rand_str
    end

    it 'returns user' do
      expect(BackendClient::User).to receive(:find).with(bare_model.user_id).and_return(user)
      expect(bare_model.user).to eq(user)
    end
  end
end
