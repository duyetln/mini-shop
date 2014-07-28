module BackendClient
  module DefaultUpdate
    def update!(*slices)
      params = to_params(*slices)
      if params.values.all?(&:present?)
        self.class.parse(
          self.class.resource["/#{id}"].put(params)
        ) do |hash|
          load!(hash)
        end
      end
    end
  end
end
