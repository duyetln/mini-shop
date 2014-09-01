require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Discounts do
  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      FactoryGirl.create :discount
    end

    context 'not paginated' do
      it 'returns all discounts' do
        send_request
        expect_status(200)
        expect_response(Discount.all.map do |discount|
          DiscountSerializer.new(discount)
        end.to_json)
      end
    end

    context 'paginated' do
      let(:params) { pagination }

      it 'returns paginated discounts' do
        send_request
        expect_status(200)
        expect_response(
          Discount.page(page,
                        size: size,
                        padn: padn
          ).all.map do |discount|
            DiscountSerializer.new(discount)
          end.to_json
        )
      end
    end
  end

  describe 'get /:id' do
    let(:method) { :get }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:discount) { FactoryGirl.create :discount }
      let(:id) { discount.id }

      it 'returns the discount' do
        send_request
        expect_status(200)
        expect_response(DiscountSerializer.new(discount).to_json)
      end
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new discount' do
        expect { send_request }.to_not change { Discount.count }
      end
    end

    context 'valid parameters' do
      let(:params) { { discount: FactoryGirl.build(:discount).attributes } }

      it 'creates new discount' do
        expect { send_request }.to change { Discount.count }.by(1)
        expect_status(200)
        expect_response(DiscountSerializer.new(Discount.last).to_json)
      end
    end
  end

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:discount) { FactoryGirl.create :discount }
      let(:id) { discount.id }

      context 'invalid parameters' do
        let(:params) { { discount: { rate: nil } } }

        include_examples 'bad request'

        it 'does not update the discount' do
          expect { send_request }.to_not change { discount.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { discount: { name: rand_str } } }

        it 'updates the existing discount' do
          expect { send_request }.to change { discount.reload.attributes }
          expect_status(200)
          expect_response(DiscountSerializer.new(discount).to_json)
        end
      end
    end
  end
end
