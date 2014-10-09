require 'controllers/spec_setup'

describe Shopping::PurchasesController do
  let(:resource_class) { BackendClient::Purchase }
  let(:resource) { purchase }

  render_views

  describe '#show' do
    let(:method) { :get }
    let(:action) { :show }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:user).at_least(:once).and_return(user)
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#return' do
    let(:method) { :put }
    let(:action) { :return }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:return!)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
