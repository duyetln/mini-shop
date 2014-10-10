module BackendClient
  module DefaultDelete
    def delete!
      load!(self.class.delete path: "/#{id}")
    end
  end
end
