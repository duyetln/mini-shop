require 'models/spec_setup'

base = ActiveRecord::Base
base.descendants.select { |klass| klass < base }.each do |klass|
  describe klass do
    context 'class' do
      let(:subject) { described_class }
      it { should respond_to(:page).with(2).argument }
    end

    describe '.page' do
      context 'no page specified' do
        it 'returns scope' do
          expect(described_class).to_not receive(:offset)
          expect(described_class).to_not receive(:limit)
          expect(described_class).to receive(:scoped).and_return(described_class)
          expect(described_class.page).to eq(described_class)
        end
      end

      context 'page, size, and padding specified' do
        let(:page) { rand_num.to_s }
        let(:size) { rand_num.to_s }
        let(:padn) { rand_num.to_s }

        it 'paginates' do
          expect(described_class).to receive(:offset).with((page.to_i - 1) * size.to_i).and_return(described_class)
          expect(described_class).to receive(:limit).with(size.to_i + padn.to_i).and_return(described_class)
          expect(described_class).to_not receive(:scoped)
          expect(described_class.page(page, size: size, padn: padn)).to eq(described_class)
        end
      end
    end
  end
end
