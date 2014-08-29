module BackendClient
  module DefaultActivate
    def activate!
      load!(self.class.put path: "/#{id}/activate")
    end
  end
end
