require 'spec/models/shared/fulfillable'

shared_examples 'orderable model' do

  it_behaves_like 'fulfillable model'

  context 'instance' do
    let(:subject) { described_class.new }
    it { should respond_to(:amount).with(1).argument }
    it { should respond_to(:item) }
  end
end
