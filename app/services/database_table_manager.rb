require './app/services/database_connection_manager'

DROP_SCRIPT_PATH = './db/scripts/drop_tables.sql'

class DatabaseTableManager
  class << self
    def drop_all
      DatabaseConnectionManager.get_connection.exec File.read DROP_SCRIPT_PATH
    end

    def migrate
      connection = DatabaseConnectionManager.get_connection

      Dir.glob('./db/migrations/*.sql').sort.each do |sql_file|
        connection.exec File.read sql_file
      end
    end
  end
end
