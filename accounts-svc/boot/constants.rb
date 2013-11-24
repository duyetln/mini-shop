ENV["RACK_ENV"] ||= "development"
SVC_ENV  = ENV["RACK_ENV"]
SVC_ROOT = File.expand_path File.join(File.dirname(__FILE__), "..")

SVC_ENV.freeze
SVC_ROOT.freeze