if Application.env == 'test'
  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  begin
    ActiveRecord::Base.transaction do
      require 'db/seeds/accounts'
      require 'db/seeds/inventory'
      require 'db/seeds/shopping'
    end
  rescue => ex
    puts ex.message
    puts ex.backtrace
  end
end
