require 'pg'

class DatabaseConnector
  def self.get_connection
    PG.connect(
      dbname: ENV['POSTGRES_DB'],
      user: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD'],
      host: ENV['POSTGRES_HOST'],
      port: ENV['POSTGRES_PORT'],
      )
  end
end
