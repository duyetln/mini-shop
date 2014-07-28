shared_examples 'default all' do
  describe '.all' do
    context 'not paginated' do
      it 'returns resource collection' do
        expect_get(nil, {}, collection(resource_payload))
        expect(described_class.all).to contain_exactly(an_instance_of(described_class))
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:params) { { page: page, size: size, padn: padn } }

      it 'returns paginated resource collection' do
        expect_get(nil, { params: params }, collection(resource_payload))
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
        expect_post(nil, described_class.params(params), resource_payload)
        expect(described_class.create(params)).to be_instance_of(described_class)
      end
    end
  end
end

shared_examples 'default find' do
  describe '.find' do
    let(:id) { rand_str }

    it 'finds resource' do
      expect_get("/#{id}")
      expect(described_class.find(id)).to be_instance_of(described_class)
    end
  end
end

shared_examples 'default update' do
  describe '#update!' do
    let(:model) { described_class.new }

    context 'slices empty' do
      it 'does nothing' do
        expect(model.update!).to be_nil
      end

      it 'does not update model' do
        expect { model.update! }.to_not change { model.attributes }
      end
    end

    context 'slices present' do
      let(:slices) { [:key1, :key3] }

      before :each do
        model.id = :id
        model.key1 = :value1
        model.key2 = :value2
      end

      it 'updates model' do
        expect_put("/#{model.id}", model.to_params(*slices))
        expect { model.update!(*slices) }.to change { model.attributes }
      end
    end
  end
end

shared_examples 'default activate' do
  describe '#activate!' do
    it 'updates model' do
      expect_put("/#{model.id}/activate")
      expect { model.activate! }.to change { model.attributes }
    end
  end
end

shared_examples 'default delete' do
  describe '#delete!' do
    it 'updates model' do
      expect_delete("/#{model.id}")
      expect { model.delete! }.to change { model.attributes }
    end
  end
end

shared_examples 'service resource' do
  describe '.namespace' do
    it 'is underscored class name' do
      expect(described_class.namespace).to eq(namespace)
    end
  end

  describe '.params' do
    it 'returns payload params' do
      expect(described_class.params(params)).to eq(described_class.namespace.to_sym => params)
    end
  end

  describe '.resource' do
    it 'returns rest client resource' do
      expect(described_class.resource).to be_a(RestClient::Resource)
    end

    it 'sets corret service url' do
      expect(described_class.resource.url).to eq("#{BackendClient::ServiceResource.host}/svc/#{namespace.pluralize}")
    end
  end
end

shared_examples 'backend client' do
  include_examples 'service resource'

  it { is_expected.to respond_to(:attributes) }
  it { is_expected.to respond_to(:to_params) }
  it { is_expected.to respond_to(:load!) }

  describe '#==' do
    let(:obj1) { described_class.new id: id1 }
    let(:obj2) { described_class.new id: id2 }

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

  describe '.instantiate' do
    it 'instantiates resource' do
      expect(instantiated_model).to be_instance_of(described_class)
    end
  end
end
