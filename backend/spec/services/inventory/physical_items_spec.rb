require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::PhysicalItems do
  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      FactoryGirl.create :physical_item
    end

    it 'returns all physical items' do
      send_request
      expect_status(200)
      expect_response(PhysicalItem.all.map do |item|
        PhysicalItemSerializer.new(item)
      end.to_json)
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new physical item' do
        expect { send_request }.to_not change { PhysicalItem.count }
      end
    end

    context 'valid parameters' do
      let(:params) { { physical_item: FactoryGirl.build(:physical_item).attributes } }

      it 'creates new physical item' do
        expect { send_request }.to change { PhysicalItem.count }.by(1)
        expect_status(200)
        expect_response(PhysicalItemSerializer.new(PhysicalItem.last).to_json)
      end
    end
  end

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:physical_item) { FactoryGirl.create :physical_item }
      let(:id) { physical_item.id }

      context 'invalid parameters' do
        let(:params) { { physical_item: { title: nil } } }

        include_examples 'bad request'

        it 'does not update the physical item' do
          expect { send_request }.to_not change { physical_item.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { physical_item: { title: rand_str } } }

        it 'updates the the physical item' do
          expect { send_request }.to change { physical_item.reload.attributes }
          expect_status(200)
          expect_response(PhysicalItemSerializer.new(physical_item).to_json)
        end
      end
    end
  end

  describe 'put /:id/activate' do
    let(:method) { :put }
    let(:path) { "/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:physical_item) { FactoryGirl.create :physical_item }
      let(:id) { physical_item.id }

      before :each do
        PhysicalItem.any_instance.stub(:activable?).and_return(activable)
      end

      context 'unactivable physical item' do
        let(:activable) { false }

        include_examples 'unprocessable'

        it 'does not update the physical item' do
          expect { send_request }.to_not change { physical_item.reload.attributes }
        end
      end

      context 'activable physical item' do
        let(:activable) { true }

        it 'activates the physical item' do
          expect { send_request }.to change { physical_item.reload.active? }.to(true)
          expect_status(200)
          expect_response(PhysicalItemSerializer.new(physical_item).to_json)
        end
      end
    end
  end

  describe 'delete /:id' do
    let(:method) { :delete }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:physical_item) { FactoryGirl.create :physical_item }
      let(:id) { physical_item.id }

      context 'deleted physical item' do
        before :each do
          expect { physical_item.delete! }.to change { physical_item.deleted? }.to(true)
        end

        include_examples 'not found'

        it 'does not update the physical item' do
          expect { send_request }.to_not change { physical_item.reload.attributes }
        end
      end

      context 'non deleted physical item' do
        before :each do
          PhysicalItem.any_instance.stub(:deletable?).and_return(deletable)
        end

        context 'deletable physical item' do
          let(:deletable) { false }

          include_examples 'unprocessable'

          it 'does not update the physical item' do
            expect { send_request }.to_not change { physical_item.reload.attributes }
          end
        end

        context 'deletable physical item' do
          let(:deletable) { true }

          it 'deletes the physical item' do
            expect { send_request }.to change { PhysicalItem.count }.by(-1)
            expect_status(200)
            expect_response(PhysicalItemSerializer.new(physical_item.reload).to_json)
          end
        end
      end
    end
  end
end
