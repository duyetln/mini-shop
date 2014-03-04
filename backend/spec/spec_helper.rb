ENV["RACK_ENV"] = "test"

require "./boot"

module SpecHelpers
  extend ActiveSupport::Concern
  include Rack::Test::Methods

  def app; described_class; end

  included do
    let(:random_string) { |length=10| Faker::Lorem.characters(length) }
    let(:sym_item_class) { item_class.to_s.underscore.to_sym }
    let(:items)        { item_class.kept }
    let(:created_item) { FactoryGirl.create(sym_item_class) }
    let(:built_item)   { FactoryGirl.build(sym_item_class) }
    let(:attributes)   { item_class.accessible_attributes.to_a.map(&:to_sym) }
    
    let(:namespace)     { item_class.to_s.tableize }
    let(:parsed_result) { Yajl::Parser.parse(last_response.body, symbolize_keys: true) }

    let(:created_user) { FactoryGirl.create :user }
    let(:built_user)   { FactoryGirl.build :user }

    def expect_status(code)
      expect(last_response.status).to eq(code)
    end

    def expect_empty_response
      expect(last_response.body).to be_empty
    end

    def expect_response(body)
      expect(last_response.body).to eq(body)
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
  config.color_enabled = true
  config.tty = true
  config.order = "random"

  config.before(:suite) { DatabaseCleaner.strategy = :truncation }  
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }
end

FactoryGirl.find_definitions