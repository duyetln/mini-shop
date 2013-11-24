ENV["RACK_ENV"] ||= "development"
APP_ENV  = ENV["RACK_ENV"]
APP_ROOT = File.expand_path File.join(File.dirname(__FILE__), "..")