require 'spec_setup'

describe BackendClient::Promotion do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '.initialize' do
    it 'sets item correctly' do
      expect(full_model.item).to be_instance_of(
        BackendClient.const_get(full_model.item.resource_type.classify)
      )
    end

    it 'sets price correctly' do
      expect(
        full_model.price
      ).to be_instance_of(BackendClient::Price)
    end
  end

  describe '#batches' do
    context 'not paginated' do
      it 'returns batches' do
        expect_http_action(:get, { path: "/#{bare_model.id}/batches", payload: {} }, [parse(batch_payload)])
        expect(
          bare_model.batches.map(&:class).uniq
        ).to contain_exactly(BackendClient::Batch)
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:sort) { :asc }
      let(:params) { { page: page, size: size, padn: padn, sort: sort } }

      it 'returns paginated batches' do
        expect_http_action(:get, { path: "/#{bare_model.id}/batches", payload: params }, [parse(batch_payload)])
        expect(
          bare_model.batches(params).map(&:class).uniq
        ).to contain_exactly(BackendClient::Batch)
      end
    end
  end

  describe '.create_batch' do
    let(:name) { rand_str }
    let(:size) { qty }

    it 'creates batch' do
      expect_http_action(:post, { path: "/#{bare_model.id}/batches", payload: BackendClient::Batch.params(name: name, size: size) })
      expect { bare_model.create_batch(name, size) }.to change { bare_model.send(:attributes) }
    end
  end

  describe '.create_batches' do
    let(:size) { qty }

    it 'creates batches' do
      expect_http_action(:post, { path: "/#{bare_model.id}/batches/generate", payload: { qty: qty }.merge(BackendClient::Batch.params(size: size)) })
      expect { bare_model.create_batches(qty, size) }.to change { bare_model.send(:attributes) }
    end
  end
end
