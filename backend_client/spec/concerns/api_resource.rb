shared_examples 'api resource' do
  describe 'http operations' do
    let(:path) { rand_str }

    def send_request
      described_class.send(http_action, path: path, payload: params, headers: headers)
    end

    shared_examples 'no error' do
      let(:http_response) { crude_payload }

      def expect_no_http_error
        expect(described_class).to receive(:resource).with(path).and_return(request)
        expect(request).to receive(http_action).with(*http_params).and_return(http_response)
      end

      it 'returns parsed result' do
        expect_no_http_error
        expect(send_request).to eq(parse(http_response))
      end
    end

    shared_examples 'error' do
      def expect_http_error
        expect(described_class).to receive(:resource).with(path).and_return(request)
        expect(request).to receive(http_action).with(*http_params).and_raise(http_error)
      end

      context 'restclient response error' do
        let(:message) { 'Message' }
        let(:meta) { 'Meta' }
        let :http_error do
          RestClient::ExceptionWithResponse.new(
            double(
              Net::HTTPResponse,
              code: http_code,
              body: { message: message, meta: meta }.to_json
            )
          )
        end

        {
          400 => BackendClient::BadRequest,
          401 => BackendClient::Unauthorized,
          403 => BackendClient::Forbidden,
          404 => BackendClient::NotFound,
          422 => BackendClient::Unprocessable,
          499 => BackendClient::ClientError,
          500 => BackendClient::ServerError,
          503 => BackendClient::Unavailable,
          599 => BackendClient::BackendError
        }.each do |error_code, error_class|
          context "#{error_code} error" do
            let!(:http_code) { error_code }

            it "raises custom #{error_class.name.demodulize.underscore.humanize.downcase} error" do
              expect_http_error
              expect { send_request }.to raise_error(error_class)
            end
          end
        end
      end

      context 'restclient exception error' do
        let(:http_error) { RestClient::Exception }

        it 'raises custom request error' do
          expect_http_error
          expect { send_request }.to raise_error(BackendClient::RequestError)
        end
      end
    end

    describe '.get' do
      let(:http_action) { :get }
      let(:http_params) { [headers.merge(params: params)] }

      include_examples 'no error'
      include_examples 'error'
    end

    describe '.post' do
      let(:http_action) { :post }
      let(:http_params) { [params, headers] }

      include_examples 'no error'
      include_examples 'error'
    end

    describe '.put' do
      let(:http_action) { :put }
      let(:http_params) { [params, headers] }

      include_examples 'no error'
      include_examples 'error'
    end

    describe '.delete' do
      let(:http_action) { :delete }
      let(:http_params) { [headers.merge(params: params)] }

      include_examples 'no error'
      include_examples 'error'
    end
  end
end
