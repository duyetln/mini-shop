shared_examples 'success response' do
  it 'returns success response' do
    send_request
    expect(response).to be_success
  end
end

shared_examples 'redirect response' do
  it 'returns redirect response' do
    send_request
    expect(response).to be_redirect
  end
end

shared_examples 'missing response' do
  it 'returns missing response' do
    send_request
    expect(response).to be_missing
  end
end

shared_examples 'error response' do
  it 'returns error response' do
    send_request
    expect(response).to be_error
  end
end

shared_examples 'non empty response' do
  it 'returns non empty resposne' do
    send_request
    expect(response_body).to be_present
  end
end

shared_examples 'empty response' do
  it 'returns empty resposne' do
    send_request
    expect(response_body).to_not be_present
  end
end

shared_examples 'info flash set' do
  it 'sets info flash' do
    send_request
    expect(flash[:info]).to be_present
  end
end

shared_examples 'success flash set' do
  it 'sets success flash' do
    send_request
    expect(flash[:success]).to be_present
  end
end

shared_examples 'warning flash set' do
  it 'sets warning flash' do
    send_request
    expect(flash[:warning]).to be_present
  end
end

shared_examples 'error flash set' do
  it 'sets error flash' do
    send_request
    expect(flash[:error]).to be_present
  end
end

shared_examples 'resource changed' do
  it 'changes resource attributes' do
    expect { send_request }.to change { resource.attributes }
  end
end

shared_examples '#activate' do
  describe '#activate' do
    let(:method) { :put }
    let(:action) { :activate }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:activate!)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end

shared_examples '#destroy' do
  describe '#destroy' do
    let(:method) { :delete }
    let(:action) { :destroy }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:delete!)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end

