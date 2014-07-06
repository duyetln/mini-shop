require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::Promotion do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets item correctly' do
      expect(model.item).to be_an_instance_of(BackendClient.const_get(model.item.resource_type.classify))
    end

    it 'sets price correctly' do
      expect(model.price).to be_an_instance_of(BackendClient::Price)
    end
  end

  describe '#batches' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:association) { :batches }
    let(:association_class) { BackendClient::Batch }
    let(:association_payload) { batch_payload }

    it 'returns association collection' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:get).and_return(collection(association_payload))
      expect(model.send(association)).to contain_exactly(an_instance_of(association_class))
    end
  end

  describe '.create_batch' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:association) { :batch }
    let(:association_class) { BackendClient::Batch }
    let(:size) { 10 }
    let(:name) { 'name' }

    it 'creates batch' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association.to_s.pluralize}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:post).with(association_class.params(name: name, size: size)).and_return(resource_payload)
      expect { model.create_batch(name, size) }.to change { model.attributes }
    end
  end
end
