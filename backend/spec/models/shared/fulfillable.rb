shared_examples 'fulfillable model' do
  context 'instance' do
    let(:subject) { described_class.new }
    it { should respond_to(:fulfill!) }
    it { should respond_to(:reverse!) }
  end
end
