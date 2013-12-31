ENV["RACK_ENV"] = "test"

require "./boot"

module SpecHelpers
  extend ActiveSupport::Concern
  include Rack::Test::Methods

  def app; described_class; end

  included do
    let(:random_string) { |length=10| rand(36**length).to_s(36) }
    let(:sym_sku_class) { sku_class.to_s.underscore.to_sym }
    let(:skus)          { sku_class.retained }
    let(:created_sku)   { FactoryGirl.create(sym_sku_class) }
    let(:built_sku)     { FactoryGirl.build(sym_sku_class) }
    let(:attributes)    { sku_class.accessible_attributes.to_a.map(&:to_sym) }
    
    let(:namespace)     { sku_class.to_s.tableize }
    let(:parsed_result) { Yajl::Parser.parse(last_response.body, symbolize_keys: true) }
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
  config.color_enabled = true
  config.tty = true

  config.before(:suite) { DatabaseCleaner.strategy = :truncation }  
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }
end

FactoryGirl.find_definitions