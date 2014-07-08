require 'spec_setup'
require 'spec/base'

describe BackendClient::Promotion do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets item correctly' do
      expect(model.item).to be_instance_of(
        BackendClient.const_get(model.item.resource_type.classify)
      )
    end

    it 'sets price correctly' do
      expect(
        model.price
      ).to be_instance_of(BackendClient::Price)
    end
  end

  describe '#batches' do
    it 'returns association collection' do
      expect_get("/#{model.id}/batches", {}, collection(batch_payload))
      expect(
        model.batches.map(&:class).uniq
      ).to contain_exactly(BackendClient::Batch)
    end
  end

  describe '.create_batch' do
    let(:name) { rand_str }
    let(:size) { qty }

    it 'creates batch' do
      expect_post("/#{model.id}/batches", BackendClient::Batch.params(name: name, size: size))
      expect { model.create_batch(name, size) }.to change { model.attributes }
    end
  end

  describe '.create_batches' do
    let(:size) { qty }

    it 'creates batches' do
      expect_post("/#{model.id}/batches/generate", { qty: qty }.merge(BackendClient::Batch.params(size: size)))
      expect { model.create_batches(qty, size) }.to change { model.attributes }
    end
  end
end
