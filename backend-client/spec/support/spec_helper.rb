module SpecHelper
  def parse(json)
    Yajl::Parser.parse(json, symbolize_keys: true)
  end

  def collection(json)
    [parse(json)].to_json
  end
end
