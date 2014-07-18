module BackendClient
  class Email
    extend ServiceResource

    def self.send_email(type, payload = {})
      if payload.present?
        parse(resource.post type: type, payload: payload) do |hash|
          response = Hashie::Mash.new(hash)
          response.date = DateTime.parse(response.date)
          response
        end
      end
    end
  end
end
