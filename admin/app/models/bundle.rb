class Bundle < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |bundle|
      bundle.bundleds.map! do |bundled|
        Bundled.instantiate(bundled)
      end
    end
  end
end
