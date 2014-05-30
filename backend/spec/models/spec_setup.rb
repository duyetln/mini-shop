require 'spec_setup'

module SpecHelpers
  module Models
    extend ActiveSupport::Concern

    included do
      let(:model_args) { [described_class.to_s.underscore.to_sym] }
      let(:model) { FactoryGirl.build(*model_args) }
      let(:subject) { model }
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers::Models

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
