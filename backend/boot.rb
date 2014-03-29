ENV['RACK_ENV'] ||= 'development'

SVC_ENV  = ENV['RACK_ENV']
SVC_ROOT = File.expand_path File.dirname(__FILE__)

$:.unshift SVC_ROOT
$:.unshift File.join(SVC_ROOT, 'lib')

Bundler.require :default, SVC_ENV.to_sym

ActiveRecord::Base.establish_connection(YAML.load_file(File.join(SVC_ROOT, 'config/database.yml'))[SVC_ENV])

Sinatra::Base.set :env,  SVC_ENV
Sinatra::Base.set :root, SVC_ROOT

CURRENCY_RATES = YAML.load_file(File.join(SVC_ROOT, 'config/currency_rates.yml'))

dirs = []
dirs << 'lib/*.rb'
dirs << 'lib/models/**/*.rb'
dirs << 'lib/services/**/*.rb'
dirs.map{ |dir| File.join(SVC_ROOT, dir) }.each { |dir| Dir[dir].each { |file| require file } }
