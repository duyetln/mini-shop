shared_examples 'default all' do
  describe '.all' do
    context 'not paginated' do
      it 'returns resource collection' do
        expect_http_action(:get, { payload: {} }, [parsed_payload])
        expect(described_class.all).to contain_exactly(an_instance_of(described_class))
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:sort) { :asc }
      let(:params) { { page: page, size: size, padn: padn, sort: sort } }

      it 'returns paginated resource collection' do
        expect_http_action(:get, { payload: params }, [parsed_payload])
        expect(described_class.all(params)).to contain_exactly(an_instance_of(described_class))
      end
    end
  end
end

shared_examples 'default create' do
  describe '.create' do
    context 'params empty' do
      it 'does nothing' do
        expect(described_class.create({})).to be_nil
      end
    end

    context 'params present' do
      it 'creates new resource' do
        expect_http_action(:post, { payload: described_class.params(params) })
        expect(described_class.create(params)).to be_instance_of(described_class)
      end
    end
  end
end

shared_examples 'default find' do
  describe '.find' do
    let(:id) { rand_str }

    it 'finds resource' do
      expect_http_action(:get, { path: "/#{id}" })
      expect(described_class.find(id)).to be_instance_of(described_class)
    end
  end
end

shared_examples 'default update' do
  describe '#update!' do
    context 'slices empty' do
      it 'does nothing' do
        expect(bare_model.update!).to be_nil
      end

      it 'does not update model' do
        expect { bare_model.update! }.to_not change { bare_model.send(:attributes) }
      end
    end

    context 'slices present' do
      let(:slices) { [:key1, :key3] }

      before :each do
        bare_model.key1 = :value1
        bare_model.key2 = :value2
      end

      it 'updates model' do
        expect_http_action(:put, { path: "/#{bare_model.id}", payload: bare_model.to_params(*slices) })
        expect { bare_model.update!(*slices) }.to change { bare_model.send(:attributes) }
      end
    end
  end
end

shared_examples 'default activate' do
  describe '#activate!' do
    it 'updates model' do
      expect_http_action(:put, { path: "/#{bare_model.id}/activate" })
      expect { bare_model.activate! }.to change { bare_model.send(:attributes) }
    end
  end
end

shared_examples 'default delete' do
  describe '#delete!' do
    it 'updates model' do
      expect_http_action(:delete, { path: "/#{bare_model.id}" })
      expect { bare_model.delete! }.to change { bare_model.send(:attributes) }
    end
  end
end