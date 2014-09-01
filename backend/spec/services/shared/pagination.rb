shared_examples 'pagination' do
  context 'not paginated' do
    it 'returns full result' do
      send_request
      expect_status(200)
      expect_response(
        scope.order("id desc").all.map do |resource|
          serializer.new(resource)
        end.to_json
      )
    end
  end

  context 'paginated' do
    let(:params) { pagination }

    it 'returns paginated result' do
      send_request
      expect_status(200)
      expect_response(
        scope.order("id #{sort}").page(
          page,
          size: size,
          padn: padn
        ).all.map do |resource|
          serializer.new(resource)
        end.to_json
      )
    end
  end
end
