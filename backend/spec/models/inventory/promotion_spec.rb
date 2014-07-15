require 'models/spec_setup'
require 'spec/models/shared/deletable'
require 'spec/models/shared/displayable'
require 'spec/models/shared/activable'
require 'spec/models/shared/itemable'
require 'spec/models/shared/priceable'
require 'spec/models/shared/orderable'

describe Promotion do
  it_behaves_like 'deletable model'
  it_behaves_like 'displayable model'
  it_behaves_like 'activable model'
  it_behaves_like 'itemable model'
  it_behaves_like 'priceable model'
  it_behaves_like 'orderable model'
end

describe Promotion do
  it { should have_many(:batches).inverse_of(:promotion) }

  it { should validate_presence_of(:name) }
  it { should ensure_inclusion_of(:item_type).in_array(%w(Bundle DigitalItem PhysicalItem)) }

  describe '#activable?' do
    it 'equals item being active and itself being inactive' do
      expect(model.activable?).to eq(model.item.active? && model.inactive?)
    end
  end

  describe '#deletable?' do
    it 'equals item being deleted and itself being kept' do
      expect(model.deletable?).to eq(model.inactive? && model.kept?)
    end
  end

  describe '#create_batch' do
    let(:batch) { model.batches.last }
    let(:batch_size) { 2 }
    let(:batch_name) { 'batch name' }

    before :each do
      model.save!
    end

    it 'creates a batch with codes' do
      expect { model.create_batch(batch_name, batch_size) }.to change { model.batches.count }.by(1)
      expect(batch.coupons.count).to eq(batch_size)
      expect(batch.name).to eq(batch_name)
    end
  end

  describe '#create_batches' do
    let(:qty) { 5 }
    let(:batch_size) { 2 }

    before :each do
      model.save!
    end

    it 'creates batches with codes' do
      expect do
        model.create_batches(qty, batch_size).each do |batch|
          expect(batch.coupons.count).to eq(batch_size)
        end
      end.to change { model.batches.count }.by(qty)
    end
  end
end
