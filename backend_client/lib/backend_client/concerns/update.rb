module BackendClient
  module DefaultUpdate
    def update!(*slices)
      params = to_params(*slices)
      if params.values.all?(&:present?)
        load!(self.class.put path: "/#{id}", payload: params)
      end
    end
  end
end
