require 'controllers/spec_setup'

describe Inventory::BundledsController do
  let(:resource_class) { BackendClient::Bundled }
  let(:resource) { bundled }

  render_views

  describe '#destroy' do
    let(:bundle_id) { rand_str }
    let(:method) { :delete }
    let(:action) { :destroy }
    let(:params) { { id: id, bundle_id: bundle_id } }

    before :each do
      expect(BackendClient::Bundle).to receive(:find).with(bundle_id).and_return(bundle)
      expect(bundle).to receive(:delete_bundled).with(id)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
