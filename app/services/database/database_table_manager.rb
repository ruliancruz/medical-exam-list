require './app/services/database/database_connection_manager'

DROP_SCRIPT_PATH = './database/scripts/drop_tables.sql'.freeze
MIGRATIONS_PATH = './database/migrations/*.sql'.freeze

class DatabaseTableManager
  class << self
    def drop_all
      DatabaseConnectionManager.use_connection do |connection|
        connection.exec File.read DROP_SCRIPT_PATH
      end
    end

    def migrate
      DatabaseConnectionManager.use_connection do |connection|
        Dir.glob(MIGRATIONS_PATH).sort.each do |sql_file|
          connection.exec File.read sql_file
        end
      end
    end
  end
end
