env = (ENV['APP_ENV'] ||= 'development')
Bundler.require :default, env.to_sym
$LOAD_PATH.unshift File.expand_path File.dirname(__FILE__)
Dir['lib/**/*.rb'].each { |f| require f }
