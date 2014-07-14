require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::DigitalItems do
  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      FactoryGirl.create :digital_item
    end

    context 'not paginated' do
      it 'returns all digital items' do
        send_request
        expect_status(200)
        expect_response(DigitalItem.all.map do |item|
          DigitalItemSerializer.new(item)
        end.to_json)
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:params) { { page: page, size: size, padn: padn } }

      it 'returns paginated digital items' do
        send_request
        expect_status(200)
        expect_response(
          DigitalItem.page(page,
            size: size,
            padn: padn
          ).all.map do |item|
            DigitalItemSerializer.new(item)
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
      let(:digital_item) { FactoryGirl.create :digital_item }
      let(:id) { digital_item.id }

      it 'returns the user' do
        send_request
        expect_status(200)
        expect_response(DigitalItemSerializer.new(digital_item).to_json)
      end
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new digital item' do
        expect { send_request }.to_not change { DigitalItem.count }
      end
    end

    context 'valid parameters' do
      let(:params) { { digital_item: FactoryGirl.build(:digital_item).attributes } }

      it 'creates new digital item' do
        expect { send_request }.to change { DigitalItem.count }.by(1)
        expect_status(200)
        expect_response(DigitalItemSerializer.new(DigitalItem.last).to_json)
      end
    end
  end

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:digital_item) { FactoryGirl.create :digital_item }
      let(:id) { digital_item.id }

      context 'invalid parameters' do
        let(:params) { { digital_item: { title: nil } } }

        include_examples 'bad request'

        it 'does not update the digital item' do
          expect { send_request }.to_not change { digital_item.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { digital_item: { title: rand_str } } }

        it 'updates the the digital item' do
          expect { send_request }.to change { digital_item.reload.attributes }
          expect_status(200)
          expect_response(DigitalItemSerializer.new(digital_item).to_json)
        end
      end
    end
  end

  describe 'put /:id/activate' do
    let(:method) { :put }
    let(:path) { "/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:digital_item) { FactoryGirl.create :digital_item }
      let(:id) { digital_item.id }

      before :each do
        DigitalItem.any_instance.stub(:activable?).and_return(activable)
      end

      context 'unactivable digital item' do
        let(:activable) { false }

        include_examples 'unprocessable'

        it 'does not update the digital item' do
          expect { send_request }.to_not change { digital_item.reload.attributes }
        end
      end

      context 'activable digital item' do
        let(:activable) { true }

        it 'activates the digital item' do
          expect { send_request }.to change { digital_item.reload.active? }.to(true)
          expect_status(200)
          expect_response(DigitalItemSerializer.new(digital_item).to_json)
        end
      end
    end
  end

  describe 'delete /:id' do
    let(:method) { :delete }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:digital_item) { FactoryGirl.create :digital_item }
      let(:id) { digital_item.id }

      context 'deleted digital item' do
        before :each do
          expect { digital_item.delete! }.to change { digital_item.deleted? }.to(true)
        end

        include_examples 'not found'

        it 'does not update the digital item' do
          expect { send_request }.to_not change { digital_item.reload.attributes }
        end
      end

      context 'non deleted digital item' do
        before :each do
          DigitalItem.any_instance.stub(:deletable?).and_return(deletable)
        end

        context 'deletable digital item' do
          let(:deletable) { false }

          include_examples 'unprocessable'

          it 'does not update the digital item' do
            expect { send_request }.to_not change { digital_item.reload.attributes }
          end
        end

        context 'deletable digital item' do
          let(:deletable) { true }

          it 'deletes the digital item' do
            expect { send_request }.to change { DigitalItem.count }.by(-1)
            expect_status(200)
            expect_response(DigitalItemSerializer.new(digital_item.reload).to_json)
          end
        end
      end
    end
  end
end
