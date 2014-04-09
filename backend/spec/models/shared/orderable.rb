shared_examples 'orderable model' do

  context 'instance' do
    let(:subject) { described_class.new }
    it { should respond_to(:amount).with(1).argument }
    it { should respond_to(:prepare!).with(2).argument }
  end

end
