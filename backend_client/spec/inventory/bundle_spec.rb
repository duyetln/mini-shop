require 'spec_setup'

describe BackendClient::Bundle do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '.initialize' do
    it 'sets bundleds correctly' do
      expect(
        full_model.bundleds.map(&:class).uniq
      ).to contain_exactly(BackendClient::Bundled)
    end
  end

  describe '.add_or_update_bundled' do
    context 'params emtpy' do
      it 'does nothing' do
        expect(bare_model.add_or_update_bundled({})).to be_nil
      end
    end

    context 'params present' do
      it 'creates bundled' do
        expect_http_action(:post, { path: "/#{bare_model.id}/bundleds", payload: BackendClient::Bundled.params(params) })
        expect do
          expect(
            bare_model.add_or_update_bundled(params)
          ).to be_instance_of(BackendClient::Bundled)
        end.to change { bare_model.send(:attributes) }
      end
    end
  end

  describe '.delete_bundled' do
    let(:bundled_id) { rand_str }

    it 'deletes bundled' do
      expect_http_action(:delete, { path: "/#{bare_model.id}/bundleds/#{bundled_id}" })
      expect do
        expect(bare_model.delete_bundled(bundled_id)).to eq(bare_model.bundleds.count)
      end.to change { bare_model.send(:attributes) }
    end
  end
end
