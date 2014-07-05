require 'spec_setup'
require 'spec/models/service_resource'

describe Bundle do
  include_examples 'service resource'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets bundleds correctly' do
      expect(model.bundleds).to contain_exactly(
        an_instance_of(Bundled),
        an_instance_of(Bundled),
        an_instance_of(Bundled),
        an_instance_of(Bundled)
      )
    end
  end

  describe '.create_bundled' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:association) { :bundled }
    let(:association_class) { Bundled }
    let(:association_payload) { bundled_payload }

    context 'params emtpy' do
      it 'does nothing' do
        expect(model.create_bundled({})).to be_nil
      end
    end

    context 'params present' do
      let(:params) { { foo: 'foo', bar: 'bar' } }

      it 'creates bundled' do
        expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association.to_s.pluralize}").and_return(doubled_resource)
        expect(doubled_resource).to receive(:post).with(association_class.params(params)).and_return(resource_payload)
        expect do
          expect(model.create_bundled(params)).to be_an_instance_of(association_class)
        end.to change { model.attributes }
      end
    end
  end

  describe '.delete_bundled' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:bundled_id) { :bundled_id }

    it 'deletes bundled' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/bundleds/#{bundled_id}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:delete).and_return(resource_payload)
      expect do
        expect(model.delete_bundled(bundled_id)).to be_an_instance_of(Fixnum)
      end.to change { model.attributes }
    end
  end
end
