shared_examples 'orderable model' do

  context 'instance' do
    let(:subject) { described_class.new }
    it { should respond_to(:amount).with(1).argument }
    it { should respond_to(:item).with(0).argument }
  end

end