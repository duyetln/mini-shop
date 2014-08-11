env = ENV['RACK_ENV'] || 'development'

# load dependencies
Bundler.require :default, env.to_sym

# initialize application
Application = Hashie::Mash.new

# env
Application.env = env

# root
Application.root = File.expand_path File.dirname(__FILE__)

# connect db
ActiveRecord::Base.establish_connection(
  YAML.load_file(File.join(Application.root, 'config', 'database.yml'))[Application.env]
)

# load paths
$LOAD_PATH.unshift           Application.root
$LOAD_PATH.unshift File.join(Application.root, 'lib')

# config
I18n.enforce_available_locales = false
I18n.load_path << File.join(Application.root, 'config', 'locale.yml')
I18n.default_locale = :en
Application.config!.currency_rates = YAML.load_file(File.join(Application.root, 'config', 'currency_rates.yml'))

# load files
[
  'lib/*.rb',
  'lib/models/**/*.rb',
  'lib/services/**/*.rb'
].each do |path|
  Dir["#{Application.root}/#{path}"].each do |file|
    require file
  end
end
