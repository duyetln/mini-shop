module BackendClient
  class Email < APIResource
    def self.send_email(type, payload = {})
      if payload.present?
        response = Hashie::Mash.new(post payload: { type: type, payload: payload })
        response.date = DateTime.parse(response.date)
        response
      end
    end
  end
end
