require 'pg'
require 'connection_pool'

class DatabaseConnectionManager
  class << self
    def get_connection
      pool.with do |connection|
        yield connection if block_given?
        connection
      end
    end

    def pool
      @pool ||= generate_connection_pool
    end

    def reset_pool
      shutdown_pool
      @pool = generate_connection_pool
    end

    def shutdown_pool
      return unless @pool

      @pool.shutdown { |connection| connection.close }
      @pool = nil
    end

    private
    def generate_connection_pool
      ConnectionPool.new(
        size: ENV.fetch('DB_POOL_SIZE', 5).to_i,
        timeout: ENV.fetch('DB_TIMEOUT', 5).to_i
      ) do
        connection = PG.connect(
          dbname: ENV['POSTGRES_DB'],
          user: ENV['POSTGRES_USER'],
          password: ENV['POSTGRES_PASSWORD'],
          host: ENV['POSTGRES_HOST'],
          port: ENV['POSTGRES_PORT']
        )
      end
    end
  end
end
