require './app/services/database/database_table_manager'
require './app/services/csv_importer'

namespace :db do
  task :drop do
    DatabaseTableManager.drop_all
    puts 'Tables dropped'
  end

  task :migrate do
    puts 'Executing SQL migrations...'
    DatabaseTableManager.migrate
    puts 'SQL migrations executed'
  end

  task :import do
    puts 'Importing CSV...'
    CSVImporter.import_to_database
    puts 'CSV imported to database'
  end

  task :import_from_csv do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:import'].invoke
  end
end
