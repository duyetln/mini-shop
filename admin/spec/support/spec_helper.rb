module SpecHelper
  def parse(json)
    Yajl::Parser.parse(json, symbolize_keys: true)
  end
end
