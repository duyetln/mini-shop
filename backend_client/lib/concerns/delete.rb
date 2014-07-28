module BackendClient
  module DefaultDelete
    def delete!
      self.class.parse(
        self.class.resource["/#{id}"].delete
      ) do |hash|
        load!(hash)
      end
    end
  end
end
