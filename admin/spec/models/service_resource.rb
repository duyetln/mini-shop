shared_examples 'default all' do
  describe '.all' do
    it 'returns resource collection' do
      expect(described_class.resource).to receive(:get).and_return(collection_payload)
      expect(described_class.all).to contain_exactly(an_instance_of(described_class))
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
      let(:params) { { foo: 'foo', bar: 'bar' } }
      it 'creates new resource' do
        expect(described_class.resource).to receive(:post).with(described_class.params(params)).and_return(resource_payload)
        expect(described_class.create(params)).to be_a(described_class)
      end
    end
  end
end

shared_examples 'default find' do
  describe '.find' do
    let(:id) { :foo }

    it 'finds resource' do
      expect(described_class.resource).to receive(:[]).with("/#{id}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:get).and_return(resource_payload)
      expect(described_class.find(id)).to be_a(described_class)
    end
  end
end

shared_examples 'default update' do
  describe '#update!' do
    let(:model) { described_class.new }

    context 'attributes empty' do
      it 'does nothing' do
        expect(model.update!).to be_nil
      end

      it 'does not update model' do
        expect { model.update! }.to_not change { model.attributes }
      end
    end

    context 'attributes present' do
      before :each do
        model.id = :id
        model.foo = :bar
      end

      it 'updates model' do
        expect(described_class.resource).to receive(:[]).with("/#{model.id}").and_return(doubled_resource)
        expect(doubled_resource).to receive(:put).with(model.to_params).and_return(resource_payload)
        expect { model.update! }.to change { model.attributes }
      end
    end
  end
end

shared_examples 'default activate' do
  describe '#activate!' do
    let(:model) { described_class.new id: :id }

    it 'updates model' do
      expect(described_class.resource).to receive(:[]).with("/#{id}/activate").and_return(doubled_resource)
      expect(doubled_resource).to receive(:put).with({}).and_return(resource_payload)
      expect { model.activate! }.to change { model.attributes }
    end
  end
end

shared_examples 'default delete' do
  describe '#delete!' do
    let(:model) { described_class.new }

    it 'updates model' do
      expect(described_class.resource).to receive(:[]).with("/#{id}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:delete).and_return(resource_payload)
      expect { model.activate! }.to change { model.attributes }
    end
  end
end

shared_examples 'service resource' do
  let(:namespace) { described_class.name.underscore }
  let(:doubled_resource) { double(RestClient::Resource) }
  let(:resource_payload) { send("#{namespace}_payload".to_sym) }
  let(:collection_payload) { [parse(resource_payload)].to_json }

  it { is_expected.to respond_to(:attributes) }
  it { is_expected.to respond_to(:to_params) }
  it { is_expected.to respond_to(:namespace) }
  it { is_expected.to respond_to(:load!) }

  describe '.namespace' do
    it 'is underscored class name' do
      expect(described_class.namespace).to eq(described_class.name.underscore)
    end
  end

  describe '.params' do
    let(:params) { { foo: 'foo', bar: 'bar' } }

    it 'returns payload params' do
      expect(described_class.params(params)).to eq({ described_class.namespace.to_sym => params })
    end
  end

  describe '.resource' do
    it 'returns rest client resource' do
      expect(described_class.resource).to be_a(RestClient::Resource)
    end

    it 'sets corret service url' do
      expect(described_class.resource.url).to eq("localhost:8002/svc/#{namespace.pluralize}")
    end
  end

  describe '#==' do
    let(:obj1) { described_class.new id: id1 }
    let(:obj2) { described_class.new id: id2 }

    context 'same id' do
      let(:id1) { :foo }
      let(:id2) { id1 }

      it 'is true' do
        expect(obj1).to eq(obj2)
      end
    end

    context 'different id' do
      let(:id1) { :foo }
      let(:id2) { :bar }

      it 'is false' do
        expect(obj1).to_not eq(obj2)
      end
    end
  end

  describe '.instantiate' do
    it 'instantiates resource' do
      expect(described_class.instantiate(parse(resource_payload))).to be_an_instance_of(described_class)
    end
  end
end
