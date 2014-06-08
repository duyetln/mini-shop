require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Promotions do
  describe 'get /promotions' do
    let(:method) { :get }
    let(:path) { '/promotions' }

    before :each do
      FactoryGirl.create :promotion
    end

    it 'returns all promotions' do
      send_request
      expect_status(200)
      expect_response(Promotion.all.map do |promotion|
        PromotionSerializer.new(promotion)
      end.to_json)
    end
  end

  describe 'post /promotions' do
    let(:method) { :post }
    let(:path) { '/promotions' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new promotion' do
        expect { send_request }.to_not change { StoreItem.count }
      end
    end

    context 'valid parameters' do
      let(:discount) { FactoryGirl.create :discount, :full }
      let(:price) { FactoryGirl.create :price, discount: discount }
      let :item do
        FactoryGirl.create [
          :bundle,
          :physical_item,
          :digital_item
        ].sample
      end
      let :params do
        {
          promotion: FactoryGirl.build(
            :promotion,
            price: price,
            item: item
          ).attributes
        }
      end

      it 'creates new promotion' do
        expect { send_request }.to change { Promotion.count }.by(1)
        expect_status(200)
        expect_response(PromotionSerializer.new(Promotion.last).to_json)
      end
    end
  end

  describe 'put /promotions/:id' do
    let(:method) { :put }
    let(:path) { "/promotions/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }

      context 'invalid parameters' do
        let(:params) { { promotion: { name: nil } } }

        include_examples 'bad request'

        it 'does not update the promotion' do
          expect { send_request }.to_not change { promotion.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { promotion: { name: rand_str } } }

        it 'updates the the promotion' do
          expect { send_request }.to change { promotion.reload.attributes }
          expect_status(200)
          expect_response(PromotionSerializer.new(promotion).to_json)
        end
      end
    end
  end

  describe 'put /promotions/:id/activate' do
    let(:method) { :put }
    let(:path) { "/promotions/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }

      before :each do
        Promotion.any_instance.stub(:activable?).and_return(activable)
      end

      context 'unactivable promotion' do
        let(:activable) { false }

        include_examples 'unprocessable'

        it 'does not update the promotion' do
          expect { send_request }.to_not change { promotion.reload.attributes }
        end
      end

      context 'activable promotion' do
        let(:activable) { true }

        it 'activates the promotion' do
          expect { send_request }.to change { promotion.reload.active? }.to(true)
          expect_status(200)
          expect_response(PromotionSerializer.new(promotion).to_json)
        end
      end
    end
  end

  describe 'delete /promotions/:id' do
    let(:method) { :delete }
    let(:path) { "/promotions/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }

      context 'deleted promotion' do
        before :each do
          expect { promotion.delete! }.to change { promotion.deleted? }.to true
        end

        include_examples 'not found'

        it 'does not update the promotion' do
          expect { send_request }.to_not change { promotion.reload.attributes }
        end
      end

      context 'non deleted promotion' do
        before :each do
          Promotion.any_instance.stub(:deletable?).and_return(deletable)
        end

        context 'deletable promotion' do
          let(:deletable) { false }

          include_examples 'unprocessable'

          it 'does not update the promotion' do
            expect { send_request }.to_not change { promotion.reload.attributes }
          end
        end

        context 'deletable promotion' do
          let(:deletable) { true }

          it 'deletes the promotion' do
            expect { send_request }.to change { Promotion.count }.by(-1)
            expect_status(200)
            expect_response(PromotionSerializer.new(promotion.reload).to_json)
          end
        end
      end
    end
  end
end
