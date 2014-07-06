require 'spec_setup'
require 'spec/models/service_resource'

describe Pricepoint do
  include_examples 'service resource'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets pricepoint_prices correctly' do
      expect(model.pricepoint_prices).to contain_exactly(
        an_instance_of(PricepointPrice),
        an_instance_of(PricepointPrice),
        an_instance_of(PricepointPrice),
        an_instance_of(PricepointPrice)
      )
    end
  end

  describe '.create_pricepoint_price' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:association) { :pricepoint_price }
    let(:association_class) { PricepointPrice }

    context 'params emtpy' do
      it 'does nothing' do
        expect(model.create_pricepoint_price({})).to be_nil
      end
    end

    context 'params present' do
      let(:params) { { foo: 'foo', bar: 'bar' } }

      it 'creates pricepoint price' do
        expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association.to_s.pluralize}").and_return(doubled_resource)
        expect(doubled_resource).to receive(:post).with(association_class.params(params)).and_return(resource_payload)
        expect do
          expect(model.create_pricepoint_price(params)).to be_an_instance_of(association_class)
        end.to change { model.attributes }
      end
    end
  end
end
