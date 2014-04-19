shared_examples 'failed order fulfillment' do
  it 'is not marked as fulfilled' do
    expect(order).to_not be_fulfilled
  end

  it 'is marked as failed' do
    expect(order).to be_failed
  end

  it 'has a refund' do
    expect(order.refund).to be_present
    expect(order.refund.amount).to eq(-order.total)
    expect(order.refund.currency).to eq(order.currency)
  end

  it 'has no fulfillments' do
    expect(order.fulfillments).to be_blank
  end
end

shared_examples 'successful order fulfillment' do
  it 'is marked as fulfilled' do
    expect(order).to be_fulfilled
  end

  it 'is not marked as failed' do
    expect(order).to_not be_failed
  end

  it 'does not have a refund' do
    expect(order.refund).to be_blank
  end

  it 'has fulfillments' do
    expect(order.fulfillments).to be_present
  end
end

shared_examples 'fulfillment processing' do
  let :fulfillment do
    order.fulfillments.find do |f|
      f.item == item
    end
  end

  let :result do
    result_class.all.find do |r|
      r.order == order
    end
  end

  it 'has an item fulfillment' do
    expect(order.fulfillments.select do |f|
      f.item == item
    end.count).to eq(1)
  end

  it 'setups the fulfillment correctly' do
    expect(fulfillment.item).to eq(item)
    expect(fulfillment.order).to eq(order)
    expect(fulfillment.qty).to eq(qty)
  end

  it 'has a fulfillment result' do
    expect(result_class.all.select do |r|
      r.order == order
    end.count).to eq(1)
  end

  it 'setups the fulfillment result correctly' do
    expect(result.user).to eq(order.user)
    expect(result.order).to eq(order)
    expect(result.item).to eq(item)
    expect(result.qty).to eq(qty)
  end
end
