# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# https://relishapp.com/rspec/rspec-rails/docs
# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
#
# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
RSpec.configure do |config|
  config.color = true
  config.tty = true

  config.infer_spec_type_from_file_location!
end
