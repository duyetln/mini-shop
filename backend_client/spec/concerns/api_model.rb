shared_examples 'api model' do
  describe '#load!' do
    it 'changes model attributes' do
      expect { bare_model.send(:load!, parsed_payload) }.to change { bare_model.send(:attributes) }
    end
  end

  describe '.params' do
    it 'returns namespaced hash' do
      expect(described_class.params(params)).to eq(described_class.name.demodulize.underscore.to_sym => params)
    end
  end

  describe '.initialize' do
    it 'parses successfully' do
      expect { full_model }.to_not raise_error
    end
  end

  describe '#==' do
    let(:obj1) { described_class.new parsed_payload.merge(id: id1) }
    let(:obj2) { described_class.new parsed_payload.merge(id: id2) }

    context 'same id' do
      let(:id1) { :id1 }
      let(:id2) {  id1 }

      it 'is true' do
        expect(obj1).to eq(obj2)
      end
    end

    context 'different id' do
      let(:id1) { :id1 }
      let(:id2) { :id2 }

      it 'is false' do
        expect(obj1).to_not eq(obj2)
      end
    end
  end

  describe '#eql?' do
    let(:obj1) { described_class.new parsed_payload.merge(id: rand_str) }
    let(:obj2) { described_class.new parsed_payload.merge(id: rand_str) }

    it 'delegates to #==' do
      expect(obj1.eql?(obj2)).to eq(obj1 == obj2)
    end
  end
end
