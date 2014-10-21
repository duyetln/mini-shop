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

  describe '#reload!' do
    let!(:key) { full_model.attributes.keys.sample }
    let!(:value) { full_model[key] }

    before :each do
      full_model[key] = rand_str
    end

    it 'resets model attributes' do
      expect do
        expect(full_model.reload!).to eq(full_model)
      end.to change { full_model[key] }.to(value)
    end

    it 'clears internal cache' do
      full_model.instance_variable_set(:@cache, rand_str)
      expect { full_model.reload! }.to change { full_model.instance_variable_get(:@cache) }.to({})
    end
  end

  describe '#hash' do
    let(:obj1) { described_class.new parsed_payload.merge(id: 'id') }
    let(:obj2) { described_class.new parsed_payload.merge(id: 'id') }

    context 'same class, same id' do
      it 'produces same hash values' do
        expect(obj1.hash).to eq(obj2.hash)
      end
    end
  end
end
