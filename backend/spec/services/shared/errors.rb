shared_examples 'bad request' do
  it 'returns bad request error' do
    send_request
    expect_status(400)
  end
end

shared_examples 'unauthorized' do
  it 'returns unauthorized error' do
    send_request
    expect_status(401)
  end
end

shared_examples 'forbidden' do
  it 'returns forbidden error' do
    send_request
    expect_status(403)
  end
end

shared_examples 'not found' do
  it 'returns not found error' do
    send_request
    expect_status(404)
  end
end

shared_examples 'unprocessable' do
  it 'returns unprocessable error' do
    send_request
    expect_status(422)
  end
end

shared_examples 'too many requests' do
  it 'returns too many requests error' do
    send_request
    expect_status(429)
  end
end

shared_examples 'server error' do
  it 'returns server error error' do
    send_request
    expect_status(500)
  end
end

shared_examples 'unavailable' do
  it 'returns unavailable error' do
    send_request
    expect_status(503)
  end
end
