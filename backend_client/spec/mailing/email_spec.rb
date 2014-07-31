require 'spec_setup'

describe BackendClient::Email do
  include_examples 'api resource'

  describe '.send_email' do
    let(:type) { rand_str }

    it 'sends email' do
      expect_http_action(:post, { payload: { type: type, payload: params } })
      response = described_class.send_email(type, params)
      expect(response).to be_a(Hash)
      expect(response['date']).to be_instance_of(DateTime)
      expect(response['to']).to be_instance_of(String)
    end
  end
end
