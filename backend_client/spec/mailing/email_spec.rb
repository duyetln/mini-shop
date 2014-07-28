require 'spec_setup'
require 'spec/base'

describe BackendClient::Email do
  include_examples 'service resource'

  describe '.send_email' do
    let(:type) { rand_str }

    it 'sends email' do
      expect_post(nil, { type: type, payload: params }, resource_payload)
      response = described_class.send_email(type, params)
      expect(response).to be_a(Hash)
      expect(response['date']).to be_instance_of(DateTime)
      expect(response['to']).to be_instance_of(String)
    end
  end
end
