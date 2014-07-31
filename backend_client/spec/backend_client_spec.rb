require 'spec_setup'

describe BackendClient do
  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:url=).with(1).arguments }
  it { is_expected.to respond_to(:proxy=).with(1).arguments }

  describe '.proxy=' do
    it 'changes default proxy' do
      expect { described_class.proxy = rand_str }.to change { RestClient.proxy }
    end
  end
end
