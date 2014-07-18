require 'spec_setup'
require 'spec/base'

describe BackendClient::Bundle do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets bundleds correctly' do
      expect(
        model.bundleds.map(&:class).uniq
      ).to contain_exactly(BackendClient::Bundled)
    end
  end

  describe '.create_bundled' do
    context 'params emtpy' do
      it 'does nothing' do
        expect(model.create_bundled({})).to be_nil
      end
    end

    context 'params present' do
      it 'creates bundled' do
        expect_post("/#{model.id}/bundleds", BackendClient::Bundled.params(params))
        expect do
          expect(
            model.create_bundled(params)
          ).to be_instance_of(BackendClient::Bundled)
        end.to change { model.attributes }
      end
    end
  end

  describe '.delete_bundled' do
    let(:bundled_id) { rand_str }

    it 'deletes bundled' do
      expect_delete("/#{model.id}/bundleds/#{bundled_id}")
      expect do
        expect(model.delete_bundled(bundled_id)).to eq(model.bundleds.count)
      end.to change { model.attributes }
    end
  end
end
