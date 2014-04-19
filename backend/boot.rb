module Application
  class << self
    attr_writer :env

    def env
      @env ||= 'development'
    end

    def root=(path)
      @root = File.expand_path(path)
    end

    def root
      @root ||= File.expand_path('.')
    end

    def config
      @config ||= Hashie::Mash.new
    end

    def load_config!
      config.currency_rates = YAML.load_file('config/currency_rates.yml')
    end

    def load_path!(*paths)
      paths.each do |path|
        $LOAD_PATH.unshift File.expand_path(path)
      end
    end

    def load_bundle!
      Bundler.require :default, env.to_sym
    end

    def load_models!
      load_files! 'lib/models/**/*.rb'
    end

    def load_services!
      load_files! 'lib/services/**/*.rb'
    end

    def load_lib!
      load_files! 'lib/*.rb'
    end

    def load_files!(*paths)
      Dir[*paths].each do |file|
        require file
      end
    end

    def connect_db!
      require 'active_record'
      ActiveRecord::Base.establish_connection(YAML.load_file('config/database.yml')[env])
    end
  end
end

Application.env = ENV['RACK_ENV']
Application.root = File.dirname(__FILE__)
Application.load_path! Application.root, 'lib'
Application.load_bundle!
