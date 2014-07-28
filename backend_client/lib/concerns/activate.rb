module BackendClient
  module DefaultActivate
    def activate!
      self.class.parse(
        self.class.resource["/#{id}/activate"].put({})
      ) do |hash|
        load!(hash)
      end
    end
  end
end
