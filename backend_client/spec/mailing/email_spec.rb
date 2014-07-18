require 'spec_setup'
require 'spec/base'

describe BackendClient::Email do
  include_examples 'service resource'

  describe '.send_email' do
    let(:type) { rand_str }

    it 'sends email' do
      expect_resource
      expect(doubled_resource).to receive(:post).with(type: type, payload: params).and_return(resource_payload)
      response = described_class.send_email(type, params)
      expect(response).to be_a(Hash)
      expect(response['date']).to be_instance_of(DateTime)
      expect(response['to']).to be_instance_of(String)
    end
  end
end
