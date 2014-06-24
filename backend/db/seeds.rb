if Application.env == 'test'
  begin
    ActiveRecord::Base.transaction do
      require 'database_cleaner'
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
      require 'db/seeds/accounts'
      require 'db/seeds/inventory'
      require 'db/seeds/shopping'
    end
  rescue => ex
    puts ex.message
    puts ex.backtrace
  end
end
