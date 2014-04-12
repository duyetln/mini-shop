ENV['RACK_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  add_filter '/db/'
  add_filter '/spec/'
  add_filter '/config/'

  add_group 'models', 'lib/models'
  add_group 'services', 'lib/services'
end

require './boot'

module SpecHelpers
  module Common
    extend ActiveSupport::Concern

    included do
      let(:rand_str) { Faker::Lorem.characters(20) }
      let(:rand_num) { rand(1..50) }

      let(:currency) { FactoryGirl.build [
          :usd, 
          :eur, 
          :gbp
        ].sample 
      }
      let(:qty) { rand(1..10) }
      let(:amount) { rand(1..100) }
      let(:user) { FactoryGirl.build :user }
      let(:item) { FactoryGirl.build [
          :bundle_item, 
          :physical_item, 
          :digital_item
        ].sample 
      }
    end
  end
end

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include SpecHelpers::Common
  config.color_enabled = true
  config.tty = true
  config.order = 'random'

  config.before :suite do
    begin
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with :truncation
    end
  end
end
