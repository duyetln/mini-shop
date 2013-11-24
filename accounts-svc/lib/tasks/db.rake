namespace :db do

  task :connect do 
    require File.join(SVC_ROOT, "boot/db")
  end

  desc "Migrate the database (options: VERSION=x)"
  task :migrate => :connect do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate File.join(SVC_ROOT, "db/migrate"), ENV["VERSION"] ? ENV["VERSION"].to_i : nil
  end

  desc "Rolls the schema back to the previous version (specify steps w/ STEP=n)"
  task :rollback => :connect do
    ActiveRecord::Migrator.rollback File.join(SVC_ROOT, "db/migrate"), ENV["STEP"] ? ENV["STEP"].to_i : 1
  end

  desc "Populate database with sample data"
  task :seed => :connect do
    require File.join(SVC_ROOT, "db/seeds")
  end

end